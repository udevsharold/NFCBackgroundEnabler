ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

TARGET = iphone:clang:11.2:latest

INSTALL_TARGET_PROCESSES = nfcd

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NFCBackgroundEnabler

NFCBackgroundEnabler_FILES = $(wildcard *.xm) NBETagLockProvider/NBETagLockProvider.mm NSData+Conversion.m
NFCBackgroundEnabler_CFLAGS = -fobjc-arc
NFCBackgroundEnabler_FRAMEWORKS = CoreNFC
NFCBackgroundEnabler_LIBRARIES = rocketbootstrap
NFCBackgroundEnabler_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += nfcbackgroundenablerpreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
