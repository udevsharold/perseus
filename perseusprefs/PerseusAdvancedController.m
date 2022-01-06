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

#import "../Common.h"
#import "../PSShared.h"
#import "PerseusAdvancedController.h"

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
        
        
		//unlock apps
		PSSpecifier *unlockAppsGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
		[unlockAppsGroupSpec setProperty:@"Authenticate apps using Apple Watch. iPhone must be unlocked via Perseus and the app required to accepts authentication using device passcode. Some apps are incompatible and could be blacklisted." forKey:@"footerText"];
		[rootSpecifiers addObject:unlockAppsGroupSpec];
		
		PSSpecifier *unlockAppsSpec = [PSSpecifier preferenceSpecifierNamed:@"Unlock Apps" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
		[unlockAppsSpec setProperty:@"Unlock Apps" forKey:@"label"];
		[unlockAppsSpec setProperty:@"unlockApps" forKey:@"key"];
		[unlockAppsSpec setProperty:@YES forKey:@"default"];
		[unlockAppsSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
		[unlockAppsSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
		[rootSpecifiers addObject:unlockAppsSpec];
		
		//blacklist
		PSSpecifier *blacklistAppsSpec = [PSSpecifier preferenceSpecifierNamed:@"Blacklist Apps" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:NSClassFromString(@"ATLApplicationListMultiSelectionController") cell:PSLinkListCell edit:nil];
		[blacklistAppsSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
		[blacklistAppsSpec setProperty:@"Blacklist Apps" forKey:@"label"];
		[blacklistAppsSpec setProperty:@[
			@{@"sectionType":@"All"},
		] forKey:@"sections"];
		[blacklistAppsSpec setProperty:@"appsUnlockBlacklistedApps" forKey:@"key"];
		[blacklistAppsSpec setProperty:@NO forKey:@"defaultApplicationSwitchValue"];
		[blacklistAppsSpec setProperty:@YES forKey:@"useSearchBar"];
		[blacklistAppsSpec setProperty:@YES forKey:@"hideSearchBarWhileScrolling"];
		[blacklistAppsSpec setProperty:@YES forKey:@"alphabeticIndexingEnabled"];
		[blacklistAppsSpec setProperty:@YES forKey:@"includeIdentifiersInSearch"];
		[rootSpecifiers addObject:blacklistAppsSpec];
		
        //Banner
        PSSpecifier *enabledBannerGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [enabledBannerGroupSpec setProperty:@"Display relevant banners when Perseus is effective." forKey:@"footerText"];
        [rootSpecifiers addObject:enabledBannerGroupSpec];
        
        PSSpecifier *enabledBannerSpec = [PSSpecifier preferenceSpecifierNamed:@"Banner" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [enabledBannerSpec setProperty:@"Banner" forKey:@"label"];
        [enabledBannerSpec setProperty:@"enabledBanner" forKey:@"key"];
        [enabledBannerSpec setProperty:@YES forKey:@"default"];
        [enabledBannerSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
        [enabledBannerSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:enabledBannerSpec];
        
        //Auto lock iPhone
        PSSpecifier *autoLockIPhoneGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [autoLockIPhoneGroupSpec setProperty:@"Lock iPhone in the event where Apple Watch is no longer authenticated." forKey:@"footerText"];
        [rootSpecifiers addObject:autoLockIPhoneGroupSpec];
        
        PSSpecifier *autoLockIphoneSpec = [PSSpecifier preferenceSpecifierNamed:@"Auto Lock iPhone" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [autoLockIphoneSpec setProperty:@"Auto Lock iPhone" forKey:@"label"];
        [autoLockIphoneSpec setProperty:@"autoLockIPhone" forKey:@"key"];
        [autoLockIphoneSpec setProperty:@YES forKey:@"default"];
        [autoLockIphoneSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
        [autoLockIphoneSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:autoLockIphoneSpec];
        
        //Fast Unlock
        PSSpecifier *fastUnlockGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [fastUnlockGroupSpec setProperty:@"Increase unlock speed by utilizing cached RSSI. Disable this if 2-3 seconds delay is not an issue for you." forKey:@"footerText"];
        [rootSpecifiers addObject:fastUnlockGroupSpec];
        
        PSSpecifier *fastUnlockSpec = [PSSpecifier preferenceSpecifierNamed:@"Fast Unlock" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [fastUnlockSpec setProperty:@"Fast Unlock" forKey:@"label"];
        [fastUnlockSpec setProperty:@"fastUnlock" forKey:@"key"];
        [fastUnlockSpec setProperty:@YES forKey:@"default"];
        [fastUnlockSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
        [fastUnlockSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:fastUnlockSpec];
        
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
        [pokeTypeSpec setValues:@[@0, @1, @2/*, @3, @4*/] titles:@[@"Disable", @"Once", @"Double (BETA)"/*, @"Default", @"Prominent"*/]];
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
