//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "../Common.h"
#import "../PSShared.h"
#include "PerseusAdvancedController.h"

@implementation PerseusAdvancedController

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *rootSpecifiers = [[NSMutableArray alloc] init];
        
        
        //RSSI threshold
        PSSpecifier *rssiThresholdGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rssiThresholdGroupSpec setProperty:@"RSSI threshold for Apple Watch. The higher the value, the nearer it is to the iPhone. -60 is the recommended value." forKey:@"footerText"];
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
        
        //Disable failure vibration
        PSSpecifier *bioFailureVibrationGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [bioFailureVibrationGroupSpec setProperty:@"Disable FaceID failure vibration when Perseus is effective." forKey:@"footerText"];
        [rootSpecifiers addObject:bioFailureVibrationGroupSpec];
        
        PSSpecifier *bioFailureVibrationSpec = [PSSpecifier preferenceSpecifierNamed:@"Disable Failure Vibration" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [bioFailureVibrationSpec setProperty:@"Disable Failure Vibration" forKey:@"label"];
        [bioFailureVibrationSpec setProperty:@"deferBioFailureVibration" forKey:@"key"];
        [bioFailureVibrationSpec setProperty:@YES forKey:@"default"];
        [bioFailureVibrationSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
        [bioFailureVibrationSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:bioFailureVibrationSpec];
        
        //Poke Gizmo
        PSSpecifier *pokeTypeGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [pokeTypeGroupSpec setProperty:@"Haptic feedback on Apple Watch." forKey:@"footerText"];
        [rootSpecifiers addObject:pokeTypeGroupSpec];
        
        PSSpecifier *pokeTypeSpec = [PSSpecifier preferenceSpecifierNamed:@"Haptic Feedback" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NSClassFromString(@"PSListItemsController") cell:PSLinkListCell edit:nil];
        [pokeTypeSpec setProperty:NSClassFromString(@"PSLinkListCell") forKey:@"cellClass"];
        [pokeTypeSpec setProperty:@"Haptic Feedback" forKey:@"label"];
        [pokeTypeSpec setProperty:@(PSPokeGizmoTypeOnce) forKey:@"default"];
        [pokeTypeSpec setValues:@[@0, @1, @2/*, @3. @4*/] titles:@[@"Disable", @"Once", @"Double (BETA)"/*, @"Default", @"Prominent"*/]];
        [pokeTypeSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
        [pokeTypeSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [pokeTypeSpec setProperty:@"pokeType" forKey:@"key"];
        [rootSpecifiers addObject:pokeTypeSpec];
        
        _specifiers = rootSpecifiers;
    }
    
    return _specifiers;
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier{
    [super setPreferenceValue:value specifier:specifier];
    if ([specifier.properties[@"key"] isEqualToString:@"pokeType"]){
        pokeGizmo([value intValue]);
    }
}
@end
