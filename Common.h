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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HBLog.h>

#define kPerseusEvent "PerseusEventKey"
#define kPerseusQuery "PerseusQueryKey"

#define PERSEUS_IDENTIFIER @"com.udevs.perseus"
#define PERSEUS_NYMPH_CENTER_IDENTIFIER @"com.udevs.perseus-nypmh.center"
#define PREFS_CHANGED_NN @"com.udevs.perseus.prefschanged"
#define GIZMO_STATE_CHANGED_NN @"com.udevs.perseus.gizmostatechanged"
#define FORCE_LOCK_NN @"com.udevs.perseus.forcelock"

#define SCREEN_ON_NN @"com.apple.springboardservices.eventobserver.internalSBSEventObserverEventUndimmed"
#define SCREEN_OFF_NN @"com.apple.springboardservices.eventobserver.internalSBSEventObserverEventDimmed"

#define APPS_UNLOCK_BANNER_COOLOFF_INTERVAL 3.0
