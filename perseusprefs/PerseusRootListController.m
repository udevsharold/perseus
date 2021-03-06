//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#include "PerseusRootListController.h"

@implementation PerseusRootListController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    CGRect frame = CGRectMake(0,0,self.table.bounds.size.width,170);
    CGRect Imageframe = CGRectMake(0,10,self.table.bounds.size.width,80);
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = [UIColor colorWithRed: 0.55 green: 0.37 blue: 0.24 alpha: 1.00];
    
    
    UIImage *headerImage = [[UIImage alloc]
                            initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/PerseusPrefs.bundle"] pathForResource:@"Perseus512" ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:Imageframe];
    [imageView setImage:headerImage];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:imageView];
    
    CGRect labelFrame = CGRectMake(0,imageView.frame.origin.y + 90 ,self.table.bounds.size.width,80);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [headerLabel setText:@"Perseus"];
    [headerLabel setFont:font];
    [headerLabel setTextColor:[UIColor blackColor]];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerLabel setContentMode:UIViewContentModeScaleAspectFit];
    [headerLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [headerView addSubview:headerLabel];
    
    self.table.tableHeaderView = headerView;
    
    self.respringBtn = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(_reallyRespring)];
    self.navigationItem.rightBarButtonItem = self.respringBtn;
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        NSMutableArray *rootSpecifiers = [[NSMutableArray alloc] init];
        
        //Tweak
        PSSpecifier *tweakEnabledGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Apple Watch" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [tweakEnabledGroupSpec setProperty:@"iPhone can use your Apple Watch to unlock when Face ID detects a face with a mask. Your Apple Watch must be nearby, on your wrist, unlocked, and protected by a passcode. Your iPhone must be unlocked with passcode once after these criterion are met." forKey:@"footerText"];
        [rootSpecifiers addObject:tweakEnabledGroupSpec];
        
        PSSpecifier *tweakEnabledSpec = [PSSpecifier preferenceSpecifierNamed:@"Unlock with Apple Watch" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
        [tweakEnabledSpec setProperty:@"Unlock with Apple Watch" forKey:@"label"];
        [tweakEnabledSpec setProperty:@"enabled" forKey:@"key"];
        [tweakEnabledSpec setProperty:@YES forKey:@"default"];
        [tweakEnabledSpec setProperty:PERSEUS_IDENTIFIER forKey:@"defaults"];
        [tweakEnabledSpec setProperty:PREFS_CHANGED_NN forKey:@"PostNotification"];
        [rootSpecifiers addObject:tweakEnabledSpec];
        
        //blank
        PSSpecifier *blankSpecGroup = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:blankSpecGroup];
        
        //Advanced
        PSSpecifier *advancedGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Advanced" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:advancedGroupSpec];
        
        PSSpecifier *advancedSpec = [PSSpecifier preferenceSpecifierNamed:@"Advanced" target:nil set:nil get:nil detail:NSClassFromString(@"PerseusAdvancedController") cell:PSLinkCell edit:nil];
        [rootSpecifiers addObject:advancedSpec];
        
        //blank
        [rootSpecifiers addObject:blankSpecGroup];
        
        //Support Dev
        PSSpecifier *supportDevGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Development" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:supportDevGroupSpec];
        
        PSSpecifier *supportDevSpec = [PSSpecifier preferenceSpecifierNamed:@"Support Development" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [supportDevSpec setProperty:@"Support Development" forKey:@"label"];
        [supportDevSpec setButtonAction:@selector(donation)];
        [supportDevSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PerseusPrefs.bundle/PayPal.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:supportDevSpec];
        
        
        //Contact
        PSSpecifier *contactGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"Contact" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [rootSpecifiers addObject:contactGroupSpec];
        
        //Twitter
        PSSpecifier *twitterSpec = [PSSpecifier preferenceSpecifierNamed:@"Twitter" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [twitterSpec setProperty:@"Twitter" forKey:@"label"];
        [twitterSpec setButtonAction:@selector(twitter)];
        [twitterSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PerseusPrefs.bundle/Twitter.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:twitterSpec];
        
        //Reddit
        PSSpecifier *redditSpec = [PSSpecifier preferenceSpecifierNamed:@"Reddit" target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
        [redditSpec setProperty:@"Twitter" forKey:@"label"];
        [redditSpec setButtonAction:@selector(reddit)];
        [redditSpec setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PerseusPrefs.bundle/Reddit.png"] forKey:@"iconImage"];
        [rootSpecifiers addObject:redditSpec];
        
        //udevs
        PSSpecifier *createdByGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [createdByGroupSpec setProperty:@"Created by udevs" forKey:@"footerText"];
        [createdByGroupSpec setProperty:@1 forKey:@"footerAlignment"];
        [rootSpecifiers addObject:createdByGroupSpec];
        
        //blank
        [rootSpecifiers addObject:blankSpecGroup];
        [rootSpecifiers addObject:blankSpecGroup];
        [rootSpecifiers addObject:blankSpecGroup];

        //credit
        PSSpecifier *creditsGroupSpec = [PSSpecifier preferenceSpecifierNamed:@"" target:nil set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [creditsGroupSpec setProperty:@"Credits:\nVector by Denis Moskowitz" forKey:@"footerText"];
        [creditsGroupSpec setProperty:@1 forKey:@"footerAlignment"];
        [rootSpecifiers addObject:creditsGroupSpec];
        
        _specifiers = rootSpecifiers;
    }
    
    return _specifiers;
}

- (void)donation {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/udevs"] options:@{} completionHandler:nil];
}

- (void)twitter {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/udevs9"] options:@{} completionHandler:nil];
}

- (void)reddit {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.reddit.com/user/h4roldj"] options:@{} completionHandler:nil];
}

-(void)_reallyRespring{
    NSURL *relaunchURL = [NSURL URLWithString:@"prefs:root=Perseus"];
    SBSRelaunchAction *restartAction = [NSClassFromString(@"SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:4 targetURL:relaunchURL];
    [[NSClassFromString(@"FBSSystemService") sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
}

@end
