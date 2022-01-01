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

#import "PSNymph.h"
#import "PSAndromeda.h"
#import "PSShared.h"
#import <MobileCoreServices/LSApplicationProxy.h>
#import <objc/runtime.h>

extern __strong NSData **perseusPtr;
extern __strong NSString **harpePtr;

@implementation PSNymph

+(instancetype)sharedInstance{
	static PSNymph *sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		sharedInstance = [self new];
	});
	return sharedInstance;
}

-(instancetype)init{
	self = [super init];
	if (self) {
		_messagingCenter = [CPDistributedMessagingCenter centerNamed:PERSEUS_NYMPH_CENTER_IDENTIFIER];
		rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);
		
		[_messagingCenter runServerOnCurrentThreadProtectedByEntitlement:@"com.apple.keystore.device"];
		[_messagingCenter registerForMessageName:@"getWisdom" target:self selector:@selector(getWisdom:withUserInfo:)];
		[_messagingCenter registerForMessageName:@"sendVexillariusMessage" target:self selector:@selector(sendVexillariusMessage:withUserInfo:)];
		[_messagingCenter registerForMessageName:@"pokeGizmo" target:self selector:@selector(pokeGizmo:withUserInfo:)];
		
	}
	
	return self;
}

-(NSDictionary *)getWisdom:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
	return @{
		@"perseus" : *perseusPtr ?: @"",
		@"harpe" : *harpePtr ?: [[NSData alloc] init],
		@"rssiThreshold" : @(rssiThreshold),
		@"fastUnlock" : @(fastUnlock),
		@"unlockedWithPerseus" : @(unlockedWithPerseus),
		@"pokeType" : @(pokeType),
		@"enabled" : @(enabled),
		@"banner" : @(banner),
		@"unlockApps" : @(unlockApps),
		@"inSession" : @(inSession)
	};
}

-(void)sendVexillariusMessage:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
	PSNymphBannerOption option = [userInfo[@"option"] intValue];
	
	LSApplicationProxy *appProxy;
	if (option > PSNymphBannerOptionNone){
		NSString *bundleIdentifier = userInfo[@"bundleIdentifier"];
		appProxy = [objc_getClass("LSApplicationProxy") applicationProxyForIdentifier:bundleIdentifier];
	}
	
	const char *title = [userInfo[@"title"] UTF8String];
	if (option == PSNymphBannerOptionTitleAsAppName && appProxy && appProxy.localizedShortName.length > 0){
		title = appProxy.localizedShortName.UTF8String;
	}
	
	const char *subtitle = [userInfo[@"subtitle"] UTF8String];
	if (option == PSNymphBannerOptionSubtitleAsAppName && appProxy && appProxy.localizedShortName.length > 0){
		subtitle = appProxy.localizedShortName.UTF8String;
	}
	
	const char *imageName = [userInfo[@"imageName"] UTF8String];
	double timeout = [userInfo[@"timeout"] doubleValue];
	sendVexillariusMessage(vexillariusMessage(title, subtitle, imageName, timeout));
}

-(void)pokeGizmo:(NSString *)name withUserInfo:(NSDictionary *)userInfo{
	PSPokeGizmoType pokeType = [userInfo[@"pokeType"] ?: @(PSPokeGizmoTypeOnce) intValue];
	pokeGizmo(pokeType);
}

@end
