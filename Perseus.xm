//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Perseus.h"
#import "PSAndromeda.h"
#import "PSGizmoStateObserver.h"
#import "PrivateHeaders.h"

static BOOL enabled;
static BOOL lastOnWrist;
static BOOL lastSecurelyUnlocked;
static BOOL screenOff;
static long long rssiThreshold;
static BOOL autoLockIPhone;
int64_t currentRssi;

static NSData *perseus;
static NSString *harpe;

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
    
    if (enabled && success && !mesa && passcode){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            harpe = [[NSUUID UUID] UUIDString];
            perseus = [RNEncryptor encryptData:[passcode dataUsingEncoding:NSUTF8StringEncoding] withSettings:kRNCryptorAES256Settings password:harpe error:nil];
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
                sendGeneralPerseusQueryWithReply(^(xpc_object_t reply){
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
                            [lockScreenManager _attemptUnlockWithPasscode:passcode mesa:NO finishUIUnlock:NO completion:nil];
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
                //Delay by few seconds to allow ble scanner do its job updating the rssi
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_ATTEMPT_TO_AUTH_WITH_AW * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), autoUnlock);
            }
        }else{
            if (eventType == FACE_IN_VIEW){
                HBLogDebug(@"A cute face, 10/10 would unlock!");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DELAY_ATTEMPT_TO_AUTH_WITH_AW * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), autoUnlock);
            }
        }
    }
    return %orig;
}
%end
%end


static void reloadPrefs(){
    id enabledVal = valueForKey(@"enabled");
    enabled = enabledVal ? [enabledVal boolValue] : YES;
    id autoLockIPhoneVal = valueForKey(@"autoLockIPhone");
    autoLockIPhone = autoLockIPhoneVal ? [autoLockIPhoneVal boolValue] : YES;
    id rssiThresholdVal = valueForKey(@"rssiThreshold");
    rssiThreshold = rssiThresholdVal ? [rssiThresholdVal longLongValue] : -60;
    if (!enabled){
        perseus = nil;
        harpe = nil;
    }
}

static void gizmoStateChanged(){
    if (enabled){
        sendGeneralPerseusQueryWithReply(^(xpc_object_t reply){
            BOOL onWrist = xpc_dictionary_get_int64(reply, "pairedWatchWristState") == 3;
            BOOL securelyUnlocked = xpc_dictionary_get_int64(reply, "pairedWatchLockState") == 0;
            
            //Auto lock iPhone if AW not on wrist or locked
            if (autoLockIPhone && perseus && harpe && (lastOnWrist && !onWrist) && (lastSecurelyUnlocked && !securelyUnlocked)){
                [((SpringBoard *)[%c(SpringBoard) sharedApplication]) _simulateLockButtonPress];
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
}

static void screenUndimmed(){
    sendInvalidateRSSIPerseusQueryWithReply(NULL);
    screenOff = NO;
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
                
                if (isSpringBoard){
                    reloadPrefs();
                    //Ensure connection
                    gizmoStateChanged();
                    %init(SpringBoard);
                    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)gizmoStateChanged, (CFStringRef)GIZMO_STATE_CHANGED_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
                    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, (CFStringRef)PREFS_CHANGED_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
                    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDimmed, (CFStringRef)SCREEN_OFF_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
                    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenUndimmed, (CFStringRef)SCREEN_ON_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
                }
                
                if (isSharingd){
                    %init(Sharingd);
                    [PSGizmoStateObserver sharedInstance];
                }
            }
            
        }
    }
}
