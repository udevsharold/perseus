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

#import "PSSeeker.h"

@implementation PSSeeker

-(instancetype)init{
	if ((self = [super init])){
		_messagingCenter = [CPDistributedMessagingCenter centerNamed:PERSEUS_NYMPH_CENTER_IDENTIFIER];
		rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);
	}
	return self;
}

-(NSDictionary *)getWisdom{
	return [_messagingCenter sendMessageAndReceiveReplyName:@"getWisdom" userInfo:nil];
}

-(BOOL)sendVexillariusMessage:(NSString *)bundleIdentifier title:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName timeout:(double)timeout option:(PSNymphBannerOption)option{
	return [_messagingCenter sendMessageName:@"sendVexillariusMessage" userInfo:@{
		@"bundleIdentifier" : bundleIdentifier ?: @"",
		@"title" : title ?: @"Unlocked with Watch",
		@"subtitle" : subtitle ?: @"Perseus",
		@"imageName" : imageName ?: @"WatchSide",
		@"timeout" : @(timeout ?: 2.0),
		@"option" : @(option ?: PSNymphBannerOptionNone)
	}];
}

-(BOOL)sendVexillariusMessageWithPid:(pid_t)pid title:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName timeout:(double)timeout option:(PSNymphBannerOption)option{
	return [_messagingCenter sendMessageName:@"sendVexillariusMessage" userInfo:@{
		@"pid" : @(pid ?: -1),
		@"title" : title ?: @"Unlocked with Watch",
		@"subtitle" : subtitle ?: @"Perseus",
		@"imageName" : imageName ?: @"WatchSide",
		@"timeout" : @(timeout ?: 2.0),
		@"option" : @(option ?: PSNymphBannerOptionNone)
	}];
}

-(BOOL)pokeGizmo:(PSPokeGizmoType)pokeType{
	return [_messagingCenter sendMessageName:@"pokeGizmo" userInfo:@{
		@"pokeType" : @(pokeType)
	}];
}

@end
