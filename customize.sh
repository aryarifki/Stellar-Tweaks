#!/system/bin/sh

SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true


if [ -f "/data/adb/ksu" ]; then
    root_method="KernelSU"
elif [ "/data/adb/magisk" ]; then
    root_method="Magisk"
elif [ -f "/data/adb/ap" ]; then
    root_method="APatch"
else
    root_method="Unknown"
fi
     
module_name="Hiyorix Tweaks"
author_name="@kanaochar | カナヲ"
version_name="6.0 (6002)"

case "$root_method" in
  "KernelSU")
    module_description=" Alternative Module for 𝘗𝘦𝘳𝘧𝘰𝘳𝘮𝘢𝘯𝘤𝘦-𝘉𝘢𝘭𝘢𝘯𝘤𝘦-𝘉𝘢𝘵𝘵𝘦𝘳𝘺 | Service: Sleep (-.-)・・・💤 | KernelSU✨️ "
    ;;
  "Magisk")
    module_description=" Alternative Module for 𝘗𝘦𝘳𝘧𝘰𝘳𝘮𝘢𝘯𝘤𝘦-𝘉𝘢𝘭𝘢𝘯𝘤𝘦-𝘉𝘢𝘵𝘵𝘦𝘳𝘺 | Service: Sleep (-.-)・・・💤 | Magisk✨️ "
    ;;
  "APatch")
    module_description=" Alternative Module for 𝘗𝘦𝘳𝘧𝘰𝘳𝘮𝘢𝘯𝘤𝘦-𝘉𝘢𝘭𝘢𝘯𝘤𝘦-𝘉𝘢𝘵𝘵𝘦𝘳𝘺 | Service: Sleep (-.-)・・・💤 | APatch✨️ "
    ;;
  "Unknown")
    module_description=" Alternative Module for 𝘗𝘦𝘳𝘧𝘰𝘳𝘮𝘢𝘯𝘤𝘦-𝘉𝘢𝘭𝘢𝘯𝘤𝘦-𝘉𝘢𝘵𝘵𝘦𝘳𝘺 | Service: Sleep (-.-)・・・💤 | Unknown? "
    ;;
esac

sed -i "s/^name=.*/name=$module_name/" $MODPATH/module.prop
sed -i "s/^version=.*/version=$version_name/" $MODPATH/module.prop
sed -i "s/^author=.*/author=$author_name/" $MODPATH/module.prop
sed -i "s/^description=.*/description=$module_description/" $MODPATH/module.prop
  
  sleep 0.5
  
  ui_print "- Extracting Hiyorix Logo "
  unzip -qo "$ZIPFILE" 'shirakami_fubuki.png' -d "/data/local/tmp"
  
  sleep 0.5

  ui_print "- Setting Module Permission"
  set_perm_recursive $MODPATH 0 0 0755 0644
  unzip -o "$ZIPFILE" action.sh -d "$MODPATH" >&2
  
  sleep 0.5
  
  ui_print "- Setting gamelist"
  unzip -o "$ZIPFILE" game.txt -d "$MODPATH" >&2
  
  sleep 0.5
  
  ui_print "- Setting Lib Permission"
  chmod +x "$MODPATH/lib/lib64"
  set_perm_recursive $MODPATH/lib 0 0 0777 0755
  
  sleep 0.5
  
  ui_print "- Setting permission profiles"
  chmod +x "$MODPATH/system/bin/battery"
  chmod +x "$MODPATH/system/bin/balanced"
  chmod +x "$MODPATH/system/bin/performance"
  chmod +x "$MODPATH/system/bin/gaming"
  
  sleep 0.5
  
  ui_print "- Extracting Folder "
  unzip -o "$ZIPFILE" 'service/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'common/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  
  sleep 0.5
  
  ui_print "- Installing Hiyorix app"
  settings put global package_verifier_enable 0
  pm install -r $MODPATH/Hiyorix > /dev/null
  
  
#  if ! pm list packages | grep -q bellavita.toast; then
#	ui_print "- Installing Bellavita Toast"
#	extract "$ZIPFILE" 'toast.apk' $TMPDIR
#	pm install $MODPATH/toast.apk > /dev/null
#	rm -f $TMPDIR/toast.apk
#  else
#	ui_print "- Reinstalling Bellavita Toast"
#	extract "$ZIPFILE" 'toast.apk' $TMPDIR
#	pm install -r $MODPATH/toast.apk > /dev/null
#	rm -f $TMPDIR/toast.apk
#  fi

  sleep 0.5
  
  ui_print "- Extracting Additional Files "
  unzip -o "$ZIPFILE" service.sh -d "$MODPATH" >&2
  unzip -o "$ZIPFILE" post-fs-data.sh -d "$MODPATH" >&2
  unzip -o "$ZIPFILE" system.prop -d "$MODPATH" >&2
  
  sleep 0.5
   
  if grep -qi 'exynos' /sys/firmware/devicetree/base/model; then 
  ui_print "- Detect Soc as exynos"
  elif grep -qi 'mediatek' /sys/firmware/devicetree/base/model; then 
  ui_print "- Detect Soc as mediatek"
  elif grep -qi 'qualcomm' /sys/firmware/devicetree/base/model; then
  ui_print "- Detect Soc as snapdragon"
  elif grep -qi 'unisoc' /sys/firmware/devicetree/base/model; then
  ui_print "- Detect Soc as unisoc"
  elif grep -qi 'tensor' /sys/firmware/devicetree/base/model; then
  ui_print "- Detect Soc as tensor"
  fi
  
  sleep 0.5
  
  # revert back
  settings put global package_verifier_enable 1
  
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
  15) ui_print "- Player vs Player, who will win? " ;;
esac