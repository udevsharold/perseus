ARCHS = arm64 arm64e

TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerseusPrefs

PerseusPrefs_FILES = $(wildcard *.m) ../PSShared.mm ../PSAndromeda.mm
PerseusPrefs_FRAMEWORKS = UIKit
PerseusPrefs_PRIVATE_FRAMEWORKS = Preferences
PerseusPrefs_INSTALL_PATH = /Library/PreferenceBundles
PerseusPrefs_CFLAGS = -fobjc-arc -DPERSEUSPREFS=1

include $(THEOS_MAKE_PATH)/bundle.mk
