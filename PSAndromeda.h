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
#import <objc/runtime.h>
#import <xpc/xpc.h>
#import "PrivateHeaders.h"

typedef NS_ENUM(int64_t, PSQueryType) {
    //0 - Unexpected
    //1 - DetectDisabled
    //2 - Off Wrist
    //3 - On Wrist
    PSQueryTypeWristState = 0,
    //-1 - Unkown
    //0 - Unlocked
    //1 - Locked without AutoUnlock
    //2 - Locked with AutoUnlock
    //3 - Unlocked Without Passcode
    PSQueryTypeLockState = 1,
    PSQueryTypeNearby = 2,
    PSQueryTypeActive = 3,
    PSQueryTypeConnected = 4,
    PSQueryTypeInvalidateRSSI = 5,
    PSQueryTypeRSSI = 6,
    PSQueryTypeRSSICache = 7,
    PSQueryTypeGizmoName = 8
};

#ifdef __cplusplus
extern "C" {
#endif

void sendPerseusQueryWithReply(xpc_object_t message, xpc_handler_t handler);
void sendGeneralPerseusQueryWithReply(BOOL fastUnlock, xpc_handler_t handler);
#ifndef PERSEUSPREFS
xpc_object_t vexillariusMessage(const char *title, const char *subTitle, const char *imageName, double timeout);
void sendVexillariusMessage(xpc_object_t message);
void sendInvalidateRSSIPerseusQueryWithReply(xpc_handler_t handler);
void handlePerseusEvent(xpc_object_t event);
id valueForKey(NSString *key);
#endif

#ifdef __cplusplus
}
#endif

extern int64_t currentRssi;
extern int64_t cachedRssi;
