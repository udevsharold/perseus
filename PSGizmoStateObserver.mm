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
