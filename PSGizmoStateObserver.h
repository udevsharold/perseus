//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE.txt', which is part of this source code package.

#import "Common.h"

#define WRIST_STATE_CHANGED_NN @"com.apple.sharingd.PairedWatchWristStateChanged"
#define LOCK_STATE_CHANGED_NN @"com.apple.sharingd.PairedWatchLockStateChanged"


@interface PSGizmoStateObserver : NSObject
+(instancetype)sharedInstance;
@end
