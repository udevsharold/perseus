//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Common.h"
#import <Foundation/NSXPCConnection.h>
#import <Foundation/NSXPCInterface.h>

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
