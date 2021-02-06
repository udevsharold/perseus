ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard sharingd


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Perseus

Perseus_FILES = $(wildcard *.xm) $(wildcard *.mm) $(wildcard RNCryptor/*.m)
Perseus_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += perseusprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
