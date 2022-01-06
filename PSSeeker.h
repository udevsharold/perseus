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

#import "Common.h"
#import <RocketBootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import "PSNymph.h"
#import "PSShared.h"

@interface PSSeeker : NSObject{
	CPDistributedMessagingCenter * _messagingCenter;
}
-(NSDictionary *)getWisdom:(NSDictionary *)userInfo;
-(BOOL)sendVexillariusMessage:(NSString *)bundleIdentifier title:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName timeout:(double)timeout option:(PSNymphBannerOption)option;
-(BOOL)sendVexillariusMessageWithPid:(pid_t)pid title:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName timeout:(double)timeout option:(PSNymphBannerOption)option;
-(BOOL)pokeGizmo:(PSPokeGizmoType)pokeType;
@end
