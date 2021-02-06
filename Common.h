//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <HBLog.h>

#define kPerseusEvent "PerseusEventKey"
#define kPerseusQuery "PerseusQueryKey"

#define PERSEUS_IDENTIFIER @"com.udevs.perseus"
#define PREFS_CHANGED_NN @"com.udevs.perseus.prefschanged"
#define GIZMO_STATE_CHANGED_NN @"com.udevs.perseus.gizmostatechanged"

#define SCREEN_ON_NN @"com.apple.springboardservices.eventobserver.internalSBSEventObserverEventUndimmed"
#define SCREEN_OFF_NN @"com.apple.springboardservices.eventobserver.internalSBSEventObserverEventDimmed"
