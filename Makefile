BUNDLE_NAME = iKeywi2
iKeywi2_FILES = iKeywi2.mm
iKeywi2_INSTALL_PATH = /Library/PreferenceBundles
iKeywi2_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore AVFoundation CoreMedia
iKeywi2_PRIVATE_FRAMEWORKS = Preferences
IP_ADDRESS=10.0.1.13
RSYNC_SETTINGSx = -e "ssh -p 2222" -z
SSH_PORTx = -p 2222
SHARED_CFLAGS = -fobjc-arc
export ARCHS = armv7 armv7s arm64
export TARGET = iphone:clang::5.0

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk


internal-stage ::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/iKeywi2.plist$(ECHO_END)
	rsync $(RSYNC_SETTINGS) _/Library/PreferenceBundles/iKeywi2.bundle/* root@$(IP_ADDRESS):/Library/PreferenceBundles/iKeywi2.bundle/
	ssh root@$(IP_ADDRESS) $(SSH_PORT) killall Preferences
	
sync: stage
	rsync -z _/Library/PreferenceLoader/Preferences/iKeywi2.plist root@$(IP_ADDRESS):/Library/PreferenceLoader/Preferences/iKeywi2.plist
	ssh root@$(IP_ADDRESS) open com.apple.Preferences
	
synclocal: stage
	rsync -e "ssh -p 2222" -z _/Library/PreferenceLoader/Preferences/iKeywi2.plist root@$(IP_ADDRESS):/Library/PreferenceLoader/Preferences/iKeywi2.plist
	ssh $(IP_ADDRESS) $(SSH_PORT) killall Preferences
	
localization ::
	rsync -z Resources/zh_TW.lproj/* root@$(IP_ADDRESS):/Library/PreferenceBundles/iKeywi2.bundle/zh_TW.lproj/
	rsync -z Resources/en.lproj/* root@$(IP_ADDRESS):/Library/PreferenceBundles/iKeywi2.bundle/en.lproj/
	ssh root@$(IP_ADDRESS) killall Preferences