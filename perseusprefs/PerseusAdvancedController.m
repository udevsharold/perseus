//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "../Common.h"
#include "PerseusAdvancedController.h"

@implementation PerseusAdvancedController

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *rootSpecifiers = [[NSMutableArray alloc] init];
        
        
        //RSSI threshold
        PSSpecifier *rssiThresholdGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rssiThresholdGroupSpec setProperty:@"RSSI threshold for Apple Watch. The higher the value, the nearer it is to the iPhone. -60 is recommended value." forKey:@"footerText"];
        [rootSpecifiers addObject:rssiThresholdGroupSpec];
        
        
        PSSpecifier *rssiThresholdSpec = [PSSpecifier preferenceSpecifierNamed:@"RSSI Threshold" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSliderCell edit:nil];
        [rssiThresholdSpec setProperty:@"rssiThreshold" forKey:@"key"];
        [rssiThresholdSpec setProperty:@(-100) forKey:@"min"];
        [rssiThresholdSpec setProperty:@0 forKey:@"max"];
        [rssiThresholdSpec setProperty:@YES forKey:@"showValue"];
        [rssiThresholdSpec setProperty:@YES forKey:@"isSegmented"];
        [rssiThresholdSpec setProperty:@20 forKey:@"segmentCount"];
        [rssiThresholdSpec setProperty:@(-60) forKey:@"default"];
        [rssiThresholdSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
        [rssiThresholdSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:rssiThresholdSpec];
        
        
        //Auto lock iPhone
        PSSpecifier *autoLockIPhoneGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [autoLockIPhoneGroupSpec setProperty:@"Lock iPhone in the event where Apple Watch is not longer authenticated." forKey:@"footerText"];
        [rootSpecifiers addObject:autoLockIPhoneGroupSpec];
        
        PSSpecifier *autoLockIphoneSpec = [PSSpecifier preferenceSpecifierNamed:@"Auto Lock iPhone" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [autoLockIphoneSpec setProperty:@"Auto Lock iPhone" forKey:@"label"];
        [autoLockIphoneSpec setProperty:@"autoLockIPhone" forKey:@"key"];
        [autoLockIphoneSpec setProperty:@YES forKey:@"default"];
        [autoLockIphoneSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
        [autoLockIphoneSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:autoLockIphoneSpec];
        
        _specifiers = rootSpecifiers;
    }
    
    return _specifiers;
}
@end
