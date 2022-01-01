//    Copyright (c) 2021 udevs
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, version 3.
//
//    This program is distributed in the hope that it will be useful, but
//    WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//    General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program. If not, see <http://www.gnu.org/licenses/>.

#import "Perseus.h"
#import "PSAndromeda.h"
#import "PSShared.h"
#import "PSGizmoStateObserver.h"
#import "PSNymph.h"
#import "PSSeeker.h"
#import "PrivateHeaders.h"

long long rssiThreshold;
BOOL fastUnlock;
BOOL unlockedWithPerseus;
int pokeType;
BOOL enabled;
BOOL banner;
BOOL unlockApps;
BOOL sessionFirstInitialized;

static BOOL lastOnWrist;
static BOOL lastSecurelyUnlocked;
static BOOL screenOff;
static BOOL autoLockIPhone;
static BOOL deferBioFailureVibration;
int64_t currentRssi = 100;
int64_t cachedRssi = 100;

static NSData *perseus;
static NSString *harpe;

__strong NSData **perseusPtr = &perseus;
__strong NSString **harpePtr = &harpe;

%group CoreAuthUI
%hook FaceIdViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	
	self = %orig;
	
	if (self){
		__weak typeof(self) weakSelf = self;
		[self _performOnMainQueueWhenAppeared:^{
			
			//2 = device passcode authentication
			if ([self.internalInfo[@"Policy"] intValue] >= 2){
				
				PSSeeker *seeker = [PSSeeker new];
				NSDictionary *wisdom = [seeker getWisdom];
				
				if (wisdom){
					
					NSData *advertisedPerseus = wisdom[@"perseus"];
					NSString *advertisedHarpe = wisdom[@"harpe"];
					long long advertisedRssiThreshold = [wisdom[@"rssiThreshold"] longLongValue];
					BOOL advertisedFastUnlock = [wisdom[@"fastUnlock"] boolValue];
					BOOL advertisedUnlockedWithPerseus = [wisdom[@"unlockedWithPerseus"] boolValue];
					PSPokeGizmoType advertisedPokeType = [wisdom[@"pokeType"] intValue];
					BOOL advertisedEnabled = [wisdom[@"enabled"] boolValue];
					BOOL advertisedBanner = [wisdom[@"banner"] boolValue];
					BOOL advertisedUnlockApps = [wisdom[@"unlockApps"] boolValue];
					BOOL advertisedSessionFirstInitialized = [wisdom[@"sessionFirstInitialized"] boolValue];
					
					if (advertisedEnabled && advertisedUnlockApps && (advertisedUnlockedWithPerseus || advertisedSessionFirstInitialized) && advertisedPerseus.length > 0 && advertisedHarpe.length > 0){
						
						sendGeneralPerseusQueryWithReply(advertisedFastUnlock, ^(xpc_object_t reply){
							BOOL onWrist = xpc_dictionary_get_int64(reply, "pairedWatchWristState") == 3;
							BOOL securelyUnlocked = xpc_dictionary_get_int64(reply, "pairedWatchLockState") == 0;
							BOOL isNearby = xpc_dictionary_get_bool(reply, "nearby");
							BOOL isActive = xpc_dictionary_get_bool(reply, "active");
							BOOL isConnected = xpc_dictionary_get_bool(reply, "connected");
							int64_t rssi = xpc_dictionary_get_int64(reply, "rssi");
							
							if (onWrist && securelyUnlocked && (rssi >= advertisedRssiThreshold && rssi < 0) && isNearby && isActive && isConnected){
								NSError *error = nil;
								NSData *decryptedPerseus = [RNDecryptor decryptData:advertisedPerseus withPassword:advertisedHarpe error:&error];
								if (!error){
									NSString *passcode =  [[NSString alloc] initWithData:decryptedPerseus encoding:NSUTF8StringEncoding];
									
									LAPasscodeHelper *passcodeHelper = [LAPasscodeHelper sharedInstance];
									long long result = [passcodeHelper verifyPasswordUsingAKS:[LASecureData secureDataWithString:passcode] acmContext:weakSelf.cachedExternalizedContext.externalizedContext userId:weakSelf.internalInfo[@"UserId"] policy:weakSelf.policy options:weakSelf.options];
									
									if (result == 0){
										[weakSelf uiSuccessWithResult:@{
											@"Result" : @{
												@3 : @YES
											}
										}];
										if (advertisedPokeType > 0){
											[seeker pokeGizmo:advertisedPokeType];
										}
										if (advertisedBanner){
											[seeker sendVexillariusMessage:self.internalInfo[@"CallerId"] title:@"Authenticated" subtitle:@"Perseus" imageName:@"WatchSide" timeout:2.0 option:PSNymphBannerOptionSubtitleAsAppName];
										}
									}else{
										[weakSelf uiFailureWithError:[LAErrorHelper internalErrorWithMessage:@"Unexpected error while attempting to unlock using Perseus."]];
									}
								}
							}
						});
					}
				}
			}
		}];
	}
	return self;
}

%end
%end


%group Sharingd
%hookf(void, xpc_connection_set_event_handler, xpc_connection_t connection, xpc_handler_t handler){
	
	if (connection){
		xpc_handler_t originalHandler = handler;
		handler = ^(xpc_object_t event){
			if (event){
				if (xpc_get_type(event) == XPC_TYPE_DICTIONARY){
					
					BOOL isPerseusEvent = xpc_dictionary_get_bool(event, kPerseusEvent);
					if (isPerseusEvent){
						handlePerseusEvent(event);
						return;
					}
				}
			}
			if (originalHandler)
				originalHandler(event);
		};
	}
	%orig;
}

%hook SDNearbyAgent
- (void)_deviceDiscoveryBLEDeviceFound:(SFBLEDevice *)bleDevice type:(long long)type{
	if ([[bleDevice valueForKey:@"_advertisementFields"][@"model"] hasPrefix:@"Watch"] && bleDevice.paired){
		cachedRssi = bleDevice.rssi;
		currentRssi = bleDevice.rssi;
		
	}
	%orig;
}

%end
%end

%group SpringBoard
%hook SBLockScreenManager
-(BOOL)_attemptUnlockWithPasscode:(NSString *)passcode mesa:(BOOL)mesa finishUIUnlock:(BOOL)unlockUI completion:(/*^block*/id)completionHandler{
	BOOL success = %orig;
	
	if (enabled && success && !mesa && passcode && !perseus && !self.isUILocked){
		sendGeneralPerseusQueryWithReply(fastUnlock, ^(xpc_object_t reply){
			BOOL onWrist = xpc_dictionary_get_int64(reply, "pairedWatchWristState") == 3;
			if (onWrist){
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
					NSError *error = nil;
					harpe = [[NSUUID UUID] UUIDString];
					perseus = [RNEncryptor encryptData:[passcode dataUsingEncoding:NSUTF8StringEncoding] withSettings:kRNCryptorAES256Settings password:harpe error:&error];
					sessionFirstInitialized = YES;
					if (banner && !error){
						sendVexillariusMessage(vexillariusMessage("Session Begins", "Perseus", "Perseus", 2.0));
					}
				});
			}
		});
	}
	
	return success;
	
}
%end


%hook CSUserPresenceMonitor //CSFaceOcclusionMonitor for iOS 13.5, but this works for <13.5, so whatever
-(BOOL)_handleBiometricEvent:(unsigned long long)eventType{
	HBLogDebug(@"eventType: %llu", eventType);
	
	if (enabled){
		static void (^autoUnlock)() = ^{
			BOOL isUILocked = [[objc_getClass("SBLockScreenManager") sharedInstance] isUILocked];
			
			if (isUILocked && !screenOff){
				sendGeneralPerseusQueryWithReply(fastUnlock, ^(xpc_object_t reply){
					BOOL onWrist = xpc_dictionary_get_int64(reply, "pairedWatchWristState") == 3;
					BOOL securelyUnlocked = xpc_dictionary_get_int64(reply, "pairedWatchLockState") == 0;
					BOOL isNearby = xpc_dictionary_get_bool(reply, "nearby");
					BOOL isActive = xpc_dictionary_get_bool(reply, "active");
					BOOL isConnected = xpc_dictionary_get_bool(reply, "connected");
					int64_t rssi = xpc_dictionary_get_int64(reply, "rssi");
					
					HBLogDebug(@"pairedWatchWristState: %lld", xpc_dictionary_get_int64(reply, "pairedWatchWristState"));
					HBLogDebug(@"pairedWatchLockState: %lld", xpc_dictionary_get_int64(reply, "pairedWatchLockState"));
					HBLogDebug(@"nearby: %d", isNearby?1:0);
					HBLogDebug(@"active: %d", isActive?1:0);
					HBLogDebug(@"connected: %d", isConnected?1:0);
					HBLogDebug(@"rssi: %lld", rssi);
					
					
					if (onWrist && securelyUnlocked && (rssi >= rssiThreshold && rssi < 0) && isNearby && isActive && isConnected && harpe){
						NSError *error;
						
						NSData *decryptedPerseus = [RNDecryptor decryptData:perseus withPassword:harpe error:&error];
						if (!error){
							NSString *passcode =  [[NSString alloc] initWithData:decryptedPerseus encoding:NSUTF8StringEncoding];
							SBLockScreenManager *lockScreenManager = [objc_getClass("SBLockScreenManager") sharedInstance];
							
							if (!unlockedWithPerseus && pokeType > 0){
								pokeGizmo(pokeType);
							}
							if (!unlockedWithPerseus && banner){
								sendVexillariusMessage(vexillariusMessage("Unlocked with Watch", "Perseus", "WatchSide", 2.0));
							}
							
							BOOL shouldFinishUIUnlock = ([lockScreenManager.coverSheetViewController isMainPageVisible] || [lockScreenManager.coverSheetViewController isShowingTodayView]) && ![[objc_getClass("SBLockScreenManager") sharedInstance] _shouldUnlockUIOnKeyDownEvent] && ![objc_getClass("SBAssistantController") isVisible];
							
							[lockScreenManager _attemptUnlockWithPasscode:passcode mesa:NO finishUIUnlock:shouldFinishUIUnlock completion:^{
								unlockedWithPerseus = YES;
							}];
							
							lastOnWrist = onWrist;
							lastSecurelyUnlocked = securelyUnlocked;
						}
					}
					
				});
			}
		};
		
		
		if (@available(iOS 13.5, *)){
			if (eventType == BOTTOM_OF_FACE_OCCLUDED){
				HBLogDebug(@"Wearing mask, a good boy!");
				if (fastUnlock){
					//Utilize cache
					autoUnlock();
				}else{
					//Delay by few seconds to allow ble scanner do its job updating the rssi
					HBLogDebug(@"DELAYED");
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_ATTEMPT_TO_AUTH_WITH_AW * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), autoUnlock);
				}
			}
		}else{
			if (eventType == FACE_IN_VIEW){
				HBLogDebug(@"A cute face, 10/10 would unlock!");
				if (fastUnlock){
					autoUnlock();
				}else{
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_ATTEMPT_TO_AUTH_WITH_AW * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), autoUnlock);
				}
			}
		}
	}
	return %orig;
}
%end

%hook CSLockScreenPearlSettings
-(CSLockScreenBiometricFailureSettings *)failureSettings{
	CSLockScreenBiometricFailureSettings *settings = %orig;
	if (enabled && deferBioFailureVibration && perseus){
		settings.vibrate = NO;
	}else{
		settings.vibrate = YES;
	}
	return settings;
}
%end
%end


static void reloadPrefs(){
	enabled = [valueForKey(@"enabled") ?: @YES boolValue];
	banner = [valueForKey(@"enabledBanner") ?: @YES boolValue];
	autoLockIPhone = [valueForKey(@"autoLockIPhone") ?: @YES boolValue];
	fastUnlock = [valueForKey(@"fastUnlock") ?: @YES boolValue];
	rssiThreshold = [valueForKey(@"rssiThreshold") ?: @(-60) longLongValue];
	deferBioFailureVibration = [valueForKey(@"deferBioFailureVibration") ?: @YES boolValue];
	pokeType = [valueForKey(@"pokeType") ?: @(PSPokeGizmoTypeOnce) intValue];
	unlockApps = [valueForKey(@"unlockApps") ?: @YES boolValue];
	
	if (!enabled){
		perseus = nil;
		harpe = nil;
	}
}

static void lockDevice(){
	[((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress];
}

static void forceLockDeviceIfNecessary(){
	if (unlockedWithPerseus && !screenOff){
		lockDevice();
	}
}

static void gizmoStateChanged(){
	if (enabled){
		sendGeneralPerseusQueryWithReply(fastUnlock, ^(xpc_object_t reply){
			BOOL onWrist = xpc_dictionary_get_int64(reply, "pairedWatchWristState") == 3;
			BOOL securelyUnlocked = xpc_dictionary_get_int64(reply, "pairedWatchLockState") == 0;
			
			//Auto lock iPhone if AW not on wrist or locked
			if (autoLockIPhone && perseus && harpe && (lastOnWrist && !onWrist) && (lastSecurelyUnlocked && !securelyUnlocked)){
				lockDevice();
			}
			
			//Revoke token
			if (!onWrist || !securelyUnlocked){
				perseus = nil;
				harpe = nil;
			}
			
			lastOnWrist = onWrist;
			lastSecurelyUnlocked = securelyUnlocked;
		});
	}
}

static void screenDimmed(){
	screenOff = YES;
	sessionFirstInitialized = NO;
}

static void screenUndimmed(){
	sendInvalidateRSSIPerseusQueryWithReply(NULL);
	screenOff = NO;
	unlockedWithPerseus = NO;
	sessionFirstInitialized = NO;
}

%ctor{
	@autoreleasepool {
		NSArray *args = [[objc_getClass("NSProcessInfo") processInfo] arguments];
		
		if (args.count != 0) {
			NSString *executablePath = args[0];
			
			if (executablePath) {
				NSString *processName = [executablePath lastPathComponent];
				BOOL isSpringBoard = [processName isEqualToString:@"SpringBoard"];
				BOOL isSharingd = [processName isEqualToString:@"sharingd"];
				BOOL isCoreAuthUI = [processName isEqualToString:@"CoreAuthUI"];
				
				if (isSpringBoard){
					reloadPrefs();
					[PSNymph sharedInstance];
					//Ensure connection
					gizmoStateChanged();
					%init(SpringBoard);
					CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)gizmoStateChanged, (CFStringRef)GIZMO_STATE_CHANGED_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
					CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, (CFStringRef)PREFS_CHANGED_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
					CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDimmed, (CFStringRef)SCREEN_OFF_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
					CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenUndimmed, (CFStringRef)SCREEN_ON_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
					CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)forceLockDeviceIfNecessary, (CFStringRef)FORCE_LOCK_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
				}
				
				if (isSharingd){
					%init(Sharingd);
					[PSGizmoStateObserver sharedInstance];
					
				}
				
				if (isCoreAuthUI){
					%init(CoreAuthUI);
				}
			}
			
		}
	}
}
