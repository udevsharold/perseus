//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "PSGizmoStateObserver.h"

@implementation PSGizmoStateObserver

+(instancetype)sharedInstance{
    static PSGizmoStateObserver *sharedInstance = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

-(instancetype)init{
    if (self = [super init]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wristStateChanged:) name:WRIST_STATE_CHANGED_NN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockStateChanged:) name:LOCK_STATE_CHANGED_NN object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WRIST_STATE_CHANGED_NN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOCK_STATE_CHANGED_NN object:nil];
}

-(void)postNotification{
    CFNotificationCenterPostNotificationWithOptions(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)GIZMO_STATE_CHANGED_NN,  NULL, NULL, kCFNotificationDeliverImmediately);
}

-(void)wristStateChanged:(NSNotification *)notification{
    HBLogDebug(@"wristStateChanged");
    [self postNotification];
}

-(void)lockStateChanged:(NSNotification *)notification{
    HBLogDebug(@"lockStateChanged");
    [self postNotification];
}

@end
