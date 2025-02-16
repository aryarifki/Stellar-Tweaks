#!/system/bin/sh

SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

if [ -f "/data/adb/ksud" ]; then
  root_method="KernelSU"
elif [ "$(which magisk)" ]; then
  root_method="Magisk"
elif [ -f "/data/adb/ap" ]; then
  root_method="APatch"
else
  root_method="Unknown"
fi

module="Hiyorix Tweaks - 白上フブキ"
author="@kanaochar | カナヲ"
version="5.7 (5702)"

case "$root_method" in
  "KernelSU")
    description="✨ This module improves Overall performance! ✨ [ Service : Not Running ❌ ] [ Detect : KernelSU ♻️ ]"
    ;;
  "Magisk")
    description="✨ This module improves Overall performance! ✨ [ Service : Not Running ❌ ] [ Detect : Magisk ♻️ ]"
    ;;
  "APatch")
    description="✨ This module improves Overall performance! ✨ [ Service : Not Running ❌ ] [ Detect : APatch ♻️ ]"
    ;;
  "Unknown")
    description="✨ This module improves Overall performance! ✨ [ Service : Not Running ❌ ] [ Detect : Unknown ❓ ]"
    ;;
esac

sed -i "s/^name=.*/name=$module/" $MODPATH/module.prop
sed -i "s/^author=.*/author=$author/" $MODPATH/module.prop
sed -i "s/^description=.*/description=$description/" $MODPATH/module.prop
sed -i "s/^version=.*/version=$version/" $MODPATH/module.prop
  
  ui_print "- Extracting webroot"
  unzip -o "$ZIPFILE" "webroot/*" -d "$MODPATH" >&2

if [ "$KSU" = "true" ] || [ "$APATCH" = "true" ]; then
  rm "$MODPATH/action.sh"
  touch "$MODPATH/skip_mount"
  ui_print "- Ksu/Ap detected, skip mount"
fi

  ui_print "- Extracting Hiyorix Logo "
  unzip -qo "$ZIPFILE" 'shirakami_fubuki.png' -d "/data/local/tmp"

  ui_print "- Setting Module Permission"
  set_perm_recursive $MODPATH 0 0 0755 0644
  
  ui_print "- Setting Lib Permission"
  chmod +x "$MODPATH/lib/lib64"
  set_perm_recursive $MODPATH/lib 0 0 0777 0755
  
  ui_print "- Extracting Folder "
  unzip -o "$ZIPFILE" 'service/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'common/*' -d $MODPATH >&2
  
  ui_print "- Extract Toast "
  unzip -o "$ZIPFILE" toast.apk -d "$MODPATH" >&2
  
if ! pm list packages | grep -q bellavita.toast; then
	ui_print "- Installing Bellavita Toast"
	extract "$ZIPFILE" 'toast.apk' $TMPDIR
	pm install $MODPATH/toast.apk > /dev/null
	rm -f $TMPDIR/toast.apk
else
	ui_print "- Reinstalling Bellavita Toast"
	extract "$ZIPFILE" 'toast.apk' $TMPDIR
	pm install -r $MODPATH/toast.apk > /dev/null
	rm -f $TMPDIR/toast.apk
fi

  ui_print "- Setting Toast Permission"
  set_perm_recursive "${MODPATH}/toast.apk" 0 0 0755 0700
  
  ui_print "- Extracting Additional Files "
  unzip -o "$ZIPFILE" service.sh -d "$MODPATH" >&2
  unzip -o "$ZIPFILE" post-fs-data.sh -d "$MODPATH" >&2
  unzip -o "$ZIPFILE" system.prop -d "$MODPATH" >&2
  
# Easter Egg
case "$((RANDOM % 14 + 1))" in
  1) ui_print "- Fire? Dragon Attack!" ;;
  2) ui_print "- Hey Player" ;;
  3) ui_print "- Foggy? Don't Too Long!" ;;
  4) ui_print "- So Dark? Torch On Side!" ;;
  5) ui_print "- Hero? Not Again!" ;;
  6) ui_print "- Saving? Need Do It?" ;;
  7) ui_print "- Dragon's flame guides you." ;;
  8) ui_print "- Hero rises in darkness." ;;
  9) ui_print "- Tome whispers ancient secrets." ;;
  10) ui_print "- Adventure calls beyond." ;;
  11) ui_print "- Forest guards it's mysteries." ;;
  12) ui_print "- Stars predict a legend." ;;
  13) ui_print "- Bro dawg don't play with nuclear 😝" ;;
  14) ui_print "- NO, NO! no attack Palestine! " ;;
esac