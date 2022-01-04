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

@interface CPDistributedMessagingCenter ()
- (void)runServerOnCurrentThreadProtectedByEntitlement:(NSString *)entitlement;
@end

typedef NS_ENUM(NSInteger, PSNymphBannerOption){
	PSNymphBannerOptionNone,
	PSNymphBannerOptionTitleAsAppName,
	PSNymphBannerOptionSubtitleAsAppName
};

@interface PSNymph : NSObject{
	CPDistributedMessagingCenter * _messagingCenter;
	pid_t _processId;
}
+(instancetype)sharedInstance;
@end
