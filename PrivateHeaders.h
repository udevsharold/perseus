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

#import "Common.h"
#import <Foundation/NSXPCConnection.h>

//SpringBoard
@interface UISystemShellApplication : UIApplication
@end

@interface SpringBoard : UISystemShellApplication
-(void)_simulateLockButtonPress;
@end

@interface CSCoverSheetViewController : UIViewController
-(BOOL)isMainPageVisible;
-(BOOL)isShowingTodayView;
@end

@interface SBLockScreenManager : NSObject
@property (nonatomic,readonly) CSCoverSheetViewController * coverSheetViewController;
@property (readonly) BOOL isUILocked;
+(id)sharedInstance;
-(BOOL)_attemptUnlockWithPasscode:(id)arg1 mesa:(BOOL)arg2 finishUIUnlock:(BOOL)arg3 completion:(/*^block*/id)arg4 ;
-(BOOL)isUILocked;
-(BOOL)_shouldUnlockUIOnKeyDownEvent;
@end

@interface PTSettings : NSObject
@end

@interface CSLockScreenBiometricFailureSettings : PTSettings
@property (assign,nonatomic) BOOL jiggleLock;
@property (assign,nonatomic) BOOL vibrate;
@property (assign,nonatomic) BOOL showPasscode;
@property (assign,nonatomic) BOOL waitUntilButtonUp;
@end

@interface SBAssistantController : NSObject
+(BOOL)isVisible;
@end

@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * bundleIdentifier;
@end

@interface SBApplicationController : NSObject
+(id)sharedInstanceIfExists;
-(SBApplication *)applicationWithPid:(int)arg1 ;
@end

//Sharing
@interface SFBLEDevice : NSObject
@property (assign,nonatomic) BOOL paired;
@property (assign,nonatomic) long long rssi;
@property (assign,nonatomic) int rssiEstimate;
@property (assign,nonatomic) BOOL insideBubble;
@property (assign,nonatomic) BOOL insideSmallBubble;
@property (assign,nonatomic) BOOL insideMediumBubble;
@property (assign,nonatomic) long long distance;
@property (assign,nonatomic) long long smoothedRSSI;
@end

@interface SFDevice : NSObject
@property (nonatomic,copy) NSString * model;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,retain) SFBLEDevice * bleDevice;
@end

@interface SFBLEScanner : NSObject
@end

//sharingd
@interface IDSDevice : NSObject
@property (nonatomic,readonly) NSArray * linkedUserURIs;
@property (setter=setNSUUID:,nonatomic,retain) NSUUID * nsuuid;
@property (nonatomic,readonly) BOOL supportsApplePay;
@property (nonatomic,readonly) BOOL supportsTethering;
@property (nonatomic,readonly) BOOL supportsHandoff;
@property (nonatomic,readonly) BOOL supportsiCloudPairing;
@property (nonatomic,readonly) BOOL supportsSMSRelay;
@property (nonatomic,readonly) BOOL supportsMMSRelay;
@property (nonatomic,readonly) BOOL supportsPhoneCalls;
@property (nonatomic,readonly) NSArray * identities;
@property (nonatomic,readonly) NSData * pushToken;
@property (nonatomic,readonly) NSDate * lastActivityDate;
@property (nonatomic,readonly) BOOL isCloudConnected;
@property (nonatomic,readonly) NSString * uniqueID;
@property (nonatomic,readonly) NSString * uniqueIDOverride;
@property (nonatomic,readonly) NSString * modelIdentifier;
@property (nonatomic,readonly) NSString * productName;
@property (nonatomic,readonly) NSString * productVersion;
//@property (nonatomic,readonly) SCD_Struct_ID4 operatingSystemVersion;
@property (nonatomic,readonly) NSString * productBuildVersion;
@property (nonatomic,readonly) NSString * name;
@property (nonatomic,readonly) NSString * service;
@property (nonatomic,readonly) NSString * deviceColor;
@property (nonatomic,readonly) NSString * enclosureColor;
@property (nonatomic,readonly) BOOL isHSATrusted;
@property (nonatomic,readonly) BOOL isDefaultPairedDevice;
@property (nonatomic,readonly) BOOL isLocallyPaired;
@property (nonatomic,readonly) BOOL isActive;
@property (nonatomic,readonly) unsigned long long pairingProtocolVersion;
@property (nonatomic,readonly) unsigned long long minCompatibilityVersion;
@property (nonatomic,readonly) unsigned long long maxCompatibilityVersion;
@property (nonatomic,readonly) unsigned long long serviceMinCompatibilityVersion;
@property (getter=isNearby,nonatomic,readonly) BOOL nearby;
@property (getter=isConnected,nonatomic,readonly) BOOL connected;
//@property (nonatomic,readonly) IDSDestination * destination;
@property (nonatomic,readonly) BOOL locallyPresent;
@end

@interface IDSService : NSObject
@property (nonatomic,copy,readonly) NSSet * internalAccounts;
@property (nonatomic,copy,readonly) NSSet * accounts;
@property (nonatomic,copy,readonly) NSArray * devices;
@end

@interface SDXPCDaemon : NSObject
@property(retain, nonatomic) NSObject<OS_dispatch_queue> *dispatchQueue;
@end

@interface SDPairedDeviceAgent : SDXPCDaemon{
	BOOL _infoRequestForced;
}
+ (id)sharedAgent;
- (void)_idsTriggerSync;
- (void)_idsSendStateUpdate:(NSMutableDictionary *)msg;
//iOS 14
- (void)_idsSendStateUpdate:(NSMutableDictionary *)msg asWaking:(BOOL)wake;
@end

@interface SDNearbyAgent : NSObject{
	SFBLEScanner *_bleNearbyInfoScanner;
}
+ (id)sharedNearbyAgent;
- (void)_bleNearbyInfoScannerEnsureStarted;
@end

@interface SDStatusMonitor : NSObject
@property(readonly) int pairedWatchLockState;
@property(readonly) long long pairedWatchWristState;
+ (id)sharedMonitor;
@end

//NanoAudioControl
@interface PBCodable : NSObject
@end

@interface NACAudioRouteBuffer : PBCodable
@end

@protocol NACXPCInterface <NSObject>
@required
-(void)setHapticIntensity:(float)arg1;
-(void)beginObservingVolumeForTarget:(id)arg1;
-(void)beginObservingListeningModesForTarget:(id)arg1;
-(void)beginObservingAudioRoutesForCategory:(id)arg1;
-(void)endObservingVolumeForTarget:(id)arg1;
-(void)endObservingListeningModesForTarget:(id)arg1;
-(void)volumeValueForTarget:(id)arg1 result:(/*^block*/id)arg2;
-(void)volumeControlAvailabilityForTarget:(id)arg1 result:(/*^block*/id)arg2;
-(void)mutedStateForTarget:(id)arg1 result:(/*^block*/id)arg2;
-(void)hapticState:(/*^block*/id)arg1;
-(void)hapticIntensity:(/*^block*/id)arg1;
-(void)prominentHapticEnabled:(/*^block*/id)arg1;
-(void)systemMutedState:(/*^block*/id)arg1;
-(void)EULimitForTarget:(id)arg1 result:(/*^block*/id)arg2;
-(void)volumeWarningForTarget:(id)arg1 result:(/*^block*/id)arg2;
-(void)setVolumeValue:(float)arg1 forTarget:(id)arg2;
-(void)setMuted:(BOOL)arg1 forTarget:(id)arg2;
-(void)setProminentHapticEnabled:(BOOL)arg1;
-(void)setHapticState:(long long)arg1;
-(void)setSystemMuted:(BOOL)arg1;
-(void)availableListeningModesForTarget:(id)arg1 result:(/*^block*/id)arg2;
-(void)currentListeningModeForTarget:(id)arg1 result:(/*^block*/id)arg2;
-(void)setCurrentListeningMode:(id)arg1 forTarget:(id)arg2;
-(void)audioRoutesForCategory:(id)arg1 result:(/*^block*/id)arg2;
-(void)endObservingAudioRoutesForCategory:(id)arg1;
-(void)pickAudioRouteWithIdentifier:(id)arg1 category:(id)arg2;
-(void)playAudioAndHapticPreview;
-(void)playDefaultHapticPreview;
-(void)playProminentHapticPreview;
@end

// XPC
@interface NSXPCConnection (Private)
@property (copy) id interruptionHandler;
@property (copy) id invalidationHandler;
@property (retain,readonly) id remoteObjectProxy;
- (void)invalidate;
@end


//PlatterKit
@interface PLPillContentItem : NSObject
-(id)itemWithText:(id)arg1 ;
-(id)initWithAccessoryView:(id)arg1 ;
@end

@interface PLPillView : UIView
@property (nonatomic,readonly) UIView * leadingAccessoryView;
@property (nonatomic,readonly) UIView * trailingAccessoryView;
@property (nonatomic,copy) NSArray * centerContentItems;
-(id)initWithLeadingAccessoryView:(id)arg1 ;
-(id)initWithTrailingAccessoryView:(id)arg1 ;
-(id)initWithLeadingAccessoryView:(id)arg1 trailingAccessoryView:(id)arg2 ;
@end

//BannerKit
@interface BNBannerSourceLayoutDescription : NSObject
@property (nonatomic,readonly) CGSize containerSize;
@property (nonatomic,readonly) CGSize presentationSize;
@property (nonatomic,readonly) double offsetFromPresentationEdge;
@end


@interface BNBannerSource : NSObject
+(id)bannerSourceForDestination:(long long)arg1 forRequesterIdentifier:(id)arg2 ;
-(BNBannerSourceLayoutDescription *)layoutDescriptionWithError:(NSError **)arg1 ;
-(BOOL)postPresentable:(id)arg1 options:(unsigned long long)arg2 userInfo:(id)arg3 error:(NSError **)arg4 ;
@end


//CoreAuthUI
@interface SBUIRemoteAlertServiceViewController : UIViewController
-(id)_remoteViewControllerProxy;

@end

@interface LACachedExternalizedContext : NSObject
@property (nonatomic,retain) NSData * cachedExternalizedContext;
@property (nonatomic,readonly) NSData * externalizedContext;
@end

@protocol LAContextExternalizationProt <NSObject>
- (void)authMethodWithReply:(void (^)(NSData *, NSError *))arg1;
- (void)externalizedContextWithReply:(void (^)(NSData *, NSError *))arg1;

@optional
- (NSData *)synchronousExternalizedContextWithError:(id *)arg1;
@end

@protocol LAUIMechanism <LAContextExternalizationProt>
- (void)internalInfoWithReply:(void (^)(NSDictionary *))arg1;
- (void)uiFailureWithError:(NSError *)arg1;
- (void)uiSuccessWithResult:(NSDictionary *)arg1;
- (void)uiEvent:(long long)arg1 options:(NSDictionary *)arg2;
@end


@protocol LABackoffCounter
- (void)currentBackoffErrorWithReply:(void (^)(NSError *))arg1;
- (void)actionSuccess;
- (void)actionBackoffWithReply:(void (^)(NSError *))arg1;
- (void)actionFailureWithReply:(void (^)(NSError *))arg1;
@end

@interface TransitionViewController : SBUIRemoteAlertServiceViewController
@property(readonly, nonatomic) LACachedExternalizedContext *cachedExternalizedContext;
@property(readonly, nonatomic) NSDictionary *options;
@property(readonly, nonatomic) NSDictionary *internalInfo;
@property(readonly, nonatomic) long long policy;
@property(readonly, nonatomic) id <LAUIMechanism> mechanism;
@property(retain, nonatomic) id <LABackoffCounter> backoffCounter;
+ (TransitionViewController *)rootController;
- (void)uiSuccessWithResult:(NSDictionary *)arg1;
- (void)uiFailureWithError:(id)arg1;
- (void)_performOnMainQueueWhenAppeared:(id /*block*/)arg1;
- (void)_resetUI;
- (void)_dismissRemoteUIWithCompletionHandler:(id /*block*/)arg1;
- (void)dismissRemoteUIWasInvalidated:(BOOL)arg1 completionHandler:(id /*block*/)arg2;
@end

@interface FaceIdViewController : TransitionViewController
- (void)_showFailAlert;
- (void)dismissChildWithCompletionHandler:(id /*block*/)arg1;
- (void)_destroyViewControllers;
- (void)_dismiss;
@end

//LocalAuthentication
@interface LASecureData : NSObject
+(id)secureDataWithString:(id)arg1 ;
@end

@interface LAPasscodeHelper : NSObject
+(id)sharedInstance;
-(long long)verifyPasswordUsingPAM:(id)arg1 userID:(id)arg2 pamService:(id)arg3 pamUser:(id)arg4 pamToken:(id)arg5 ;
-(long long)verifyPasswordUsingAKS:(id)arg1 acmContext:(id)arg2 userId:(id)arg3 policy:(long long)arg4 options:(id)arg5 ;
@end

@interface LAErrorHelper : NSObject
+(id)internalErrorWithMessage:(id)arg1 ;
@end

@interface LAUtils : NSObject
+(BOOL)isMultiUser;
@end

//coreauthd
@protocol LAOriginatorProt
@property(readonly, nonatomic) unsigned long long originatorId;
//@property(readonly, nonatomic) id <LAContextCallbackXPC> callback;
//@property(readonly, nonatomic) CDStruct_4c969caf auditToken;
@property(readonly, nonatomic) int auditSessionId;
@property(readonly, nonatomic) unsigned int userId;
@property(readonly, nonatomic) int processId;
@property(readonly, nonatomic) BOOL cApiOrigin;
- (BOOL)checkEntitlement:(NSString *)arg1;
@end

@interface Request : NSObject
@property (nonatomic,readonly) BOOL interactive;
@end

@interface EvaluationRequest : Request
@property (nonatomic,readonly) NSDictionary * options;
@property (nonatomic,readonly) BOOL isUnlock;
@property (nonatomic,readonly) long long purpose;
@property (nonatomic,readonly) long long policy;
-(id)initWithAcl:(id)arg1 operation:(id)arg2 options:(id)arg3 ;
-(id)initWithPolicy:(long long)arg1 options:(id)arg2 ;
-(void)updateOptions:(id)arg1 ;
@end


@protocol LAUIDelegate
@required
-(void)event:(long long)arg1 params:(id)arg2 reply:(/*^block*/id)arg3;
@end

@protocol LAContextServerEvaluationProt
- (void)setShowingCoachingHint:(BOOL)arg1 event:(long long)arg2 originator:(id <LAOriginatorProt>)arg3 reply:(void (^)(BOOL, NSError *))arg4;
- (void)resetEvent:(long long)arg1 originator:(id <LAOriginatorProt>)arg2 reply:(void (^)(BOOL, NSError *))arg3;
- (void)retryEvent:(long long)arg1 originator:(id <LAOriginatorProt>)arg2 reply:(void (^)(BOOL, NSError *))arg3;
- (void)setOptions:(id)arg1 forInternalOperation:(long long)arg2 originator:(id <LAOriginatorProt>)arg3 reply:(void (^)(BOOL, NSError *))arg4;
- (void)optionsForInternalOperation:(long long)arg1 originator:(id <LAOriginatorProt>)arg2 reply:(void (^)(id, NSError *))arg3;
- (void)checkCredentialSatisfied:(long long)arg1 policy:(long long)arg2 reply:(void (^)(BOOL, NSError *))arg3;
- (void)credentialOfType:(long long)arg1 originator:(id <LAOriginatorProt>)arg2 reply:(void (^)(NSData *, NSError *))arg3;
- (void)setCredential:(NSData *)arg1 type:(long long)arg2 options:(NSDictionary *)arg3 originator:(id <LAOriginatorProt>)arg4 reply:(void (^)(BOOL, NSError *))arg5;
- (void)isCredentialSet:(long long)arg1 originator:(id <LAOriginatorProt>)arg2 reply:(void (^)(BOOL, NSError *))arg3;
- (void)evaluateACL:(NSData *)arg1 operation:(id)arg2 options:(NSDictionary *)arg3 uiDelegate:(id <LAUIDelegate>)arg4 originator:(id <LAOriginatorProt>)arg5 request:(EvaluationRequest *)arg6 reply:(void (^)(NSDictionary *, NSError *))arg7;
- (void)evaluatePolicy:(long long)arg1 options:(NSDictionary *)arg2 uiDelegate:(id <LAUIDelegate>)arg3 originator:(id <LAOriginatorProt>)arg4 request:(EvaluationRequest *)arg5 reply:(void (^)(NSDictionary *, NSError *))arg6;
@end

@protocol LAContextClientEvaluationProt
- (void)setOptions:(id)arg1 forInternalOperation:(long long)arg2 reply:(void (^)(BOOL, NSError *))arg3;
- (void)optionsForInternalOperation:(long long)arg1 reply:(void (^)(id, NSError *))arg2;
- (void)credentialOfType:(long long)arg1 reply:(void (^)(NSData *, NSError *))arg2;
- (void)invalidateWithReply:(void (^)(BOOL, NSError *))arg1;
- (void)setCredential:(NSData *)arg1 type:(long long)arg2 reply:(void (^)(BOOL, NSError *))arg3;
- (void)isCredentialSet:(long long)arg1 reply:(void (^)(BOOL, NSError *))arg2;
- (void)evaluateACL:(NSData *)arg1 operation:(id)arg2 options:(NSDictionary *)arg3 uiDelegate:(id <LAUIDelegate>)arg4 reply:(void (^)(NSDictionary *, NSError *))arg5;
- (void)evaluatePolicy:(long long)arg1 options:(NSDictionary *)arg2 uiDelegate:(id <LAUIDelegate>)arg3 reply:(void (^)(NSDictionary *, NSError *))arg4;
@end

@protocol LAContextServerSideProt <LAContextServerEvaluationProt>
@end

@interface ContextPlugin : NSObject <LAContextServerEvaluationProt>
@property (nonatomic,readonly) LACachedExternalizedContext * cachedExternalizedContext;
@property (nonatomic,retain) NSDictionary * resultInfo;
@end

@interface Context : NSObject <LAContextServerSideProt>
@property(readonly, nonatomic) NSUUID *uuid;
@property(readonly, nonatomic) NSData *externalizedContext;
@property(readonly, nonatomic) ContextPlugin *plugin;
- (BOOL)_hasProtectedOptions:(id)arg1;
- (id)_updateOptionsWithServerProperties:(id)arg1;
@end

@protocol LAContextXPC <LAContextClientEvaluationProt>
@end

@interface ContextProxy : NSObject <LAContextXPC, LAOriginatorProt>
@property(readonly, nonatomic) Context *managedContext;
@property(readonly, nonatomic) unsigned int userId;
@property(readonly, nonatomic) int processId;
@end

@interface ContextManager : NSObject
+ (id)sharedInstance;
- (id)loadModule:(long long)arg1 error:(id *)arg2;
@end

//DaemonUtils
@interface BiometryHelper : NSObject
+(id)sharedInstance;
-(NSData *)biometryDatabaseHashForUser:(NSString *)username error:(NSError **)error ;
@end

@interface InstalledAppsCache : NSObject
+(id)sharedInstance;
-(id)_bundleIDFromUUID:(id)arg1 ;
-(id)appNameForUUID:(id)arg1 bundleId:(id*)arg2 ;
-(id)lsBundleIDForUUID:(id)arg1 ;
@end


//MobileKeyBag
#define kMobileKeyBagDisabled 3
#define kMobileKeyBagSuccess (0)
#define kMobileKeyBagError (-1)

#ifdef __cplusplus
extern "C" {
#endif

int MKBGetDeviceLockState(CFDictionaryRef options);
int MKBUnlockDevice(CFDataRef passcode, CFDictionaryRef options);

#ifdef __cplusplus
}
#endif

//LAContext
//Options
#define kLAOptionUserFallback                   1
#define kLAOptionAuthenticationReason           2
#define kLAOptionReturnFingerDatabaseHash       1015
#define kLAOptionReturnBiometryDatabaseHash     kLAOptionReturnFingerDatabaseHash

//Results
#define kLAResultPassedBiometry                    1
#define kLAResultPassedPasscode                    3
#define kLAResultFingerDatabaseHash                7
#define kLAResultBiometryDatabaseHash              kLAResultFingerDatabaseHash
