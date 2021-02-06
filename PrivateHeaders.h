//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE.txt', which is part of this source code package.

#import "Common.h"

//SpringBoard
@interface UISystemShellApplication : UIApplication
@end

@interface SpringBoard : UISystemShellApplication
-(void)_simulateLockButtonPress;
@end

@interface SBLockScreenManager : NSObject
+(id)sharedInstance;
-(BOOL)_attemptUnlockWithPasscode:(id)arg1 mesa:(BOOL)arg2 finishUIUnlock:(BOOL)arg3 completion:(/*^block*/id)arg4 ;
-(BOOL)isUILocked;
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

@interface SDPairedDeviceAgent : SDXPCDaemon
+ (id)sharedAgent;
- (void)_idsTriggerSync;
@end


@interface SDStatusMonitor : NSObject
@property(readonly) int pairedWatchLockState;
@property(readonly) long long pairedWatchWristState;
+ (id)sharedMonitor;
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

