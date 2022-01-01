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
#import "RNCryptor/RNCryptor.h"
#import "RNCryptor/RNDecryptor.h"
#import "RNCryptor/RNEncryptor.h"
#import <objc/runtime.h>
#import <xpc/xpc.h>

#define DELAY_ATTEMPT_TO_AUTH_WITH_AW 2.0

#define FINGER_OFF 0
#define FINGER_ON 1
#define REQUEST_FINGER_OFF 2
#define IDENTITY_MATCH 3
#define BIO_UNLOCKED 4
#define PASSCODE_REQUIRED_GENERIC 5
#define PASSCODE_REQUIRED_BIO_LOCKOUT 6
#define PASSCODE_REQUIRED_BIO_EXPIRED 7
#define PASSCODE_REQUIRED_AFTER_REBOOT 8
#define IDENTITY_MATCH_FAILED_DIRT_ON_SENSOR 9
#define IDENTITY_MATCH_FAILED 10
#define IDENTITY_MATCH_FAILED_AND_CAUSED_BIO_LOCKOUT 11
#define MATCH_STARTED 12
#define FACE_IN_VIEW 13
#define FACE_NOT_IN_VIEW 14
#define MATCH_TIMED_OUT 15
#define NO_FEEDBACK 16
#define FACE_TOO_FAR 17
#define FACE_TOO_CLOSE 18
#define CAMERA_OBSTRUCTED 19
#define NO_ATTENTION 20
#define FACE_OCCLUDED 21
#define FACE_OUT_OF_VIEW 22
#define POSE_IS_MARGINAL 23
#define FACE_ID_INTERLOCKED 24
#define DEVICE_TOO_HOT 25
#define DEVICE_TOO_COLD 26
#define OPERATION_FAILED 27
#define BOTTOM_OF_FACE_OCCLUDED 28
