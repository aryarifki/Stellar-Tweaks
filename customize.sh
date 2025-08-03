#!/system/bin/sh

#
# Copyright (C) 2024-2025 Kanao
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

name="Stellar"
mmk_package="bellavita.toast"
basedir="/data/adb/.config/stellar"
stellar_path="/data/adb/modules/stellar"
USE_SYMLINK=false
ROOT_METHOD="Magisk"
CUSTOM_BIN_PATH=""
CHIPSET_ID=0

print_status() {
    ui_print "- $1"
    sleep 0.1
}

abort_clean() {
    ui_print " "
    ui_print "*********************************************************"
    ui_print "! ERROR: $1"
    ui_print "! Installation failed!"
    ui_print "*********************************************************"
    ui_print " "
    abort "$1"
}

safe_extract() {
    local file_pattern="$1"
    local dest="$2"
    ui_print "- Extracting $file_pattern..."
    if ! unzip -qo "$ZIPFILE" "$file_pattern" -d "$dest"; then
        abort_clean "Failed to extract $file_pattern"
    fi
}

detect_root_method() {
    print_status "Initializing installation..."
    if [ -d "/data/adb/ksu" ]; then
        ROOT_METHOD="KSU"
        CUSTOM_BIN_PATH="/data/adb/ksu/bin"
        USE_SYMLINK=true
    elif [ -d "/data/adb/ap" ]; then
        ROOT_METHOD="Apatch"
        CUSTOM_BIN_PATH="/data/adb/ap/bin"
        USE_SYMLINK=true
    fi

    if $USE_SYMLINK; then
        print_status "$ROOT_METHOD detected, using symlinks."
        rm -rf "$MODPATH/action.sh"
        touch "$MODPATH/skip_mount"
    fi
}

setup_directories_and_configs() {
    print_status "Setting up directories and configuration..."
    mkdir -p "$basedir" || abort_clean "Failed to create Stellar Directory"
    
    touch "$basedir/lock" || abort_clean "Failed to create lock file"
    touch "$basedir/soc" || abort_clean "Failed to create soc file"
    
    cat > "$basedir/×××util_natively_injection××" <<-EOF
    Injection version 7505
    Rezim_konoha guides hells
EOF

    cat > "$basedir/config" <<-EOF
    symlink=$USE_SYMLINK
    root_method=$ROOT_METHOD
    custom_bin_path=$CUSTOM_BIN_PATH
EOF
}

create_essential_files() {
    print_status "Creating essential configuration files..."
    [ ! -f "$basedir/custom_game_cpu_gov" ] && echo "performance" > "$basedir/custom_game_cpu_gov"
    [ ! -f "$basedir/custom_default_cpu_gov" ] && echo "interactive" > "$basedir/custom_default_cpu_gov"
    [ ! -f "$basedir/custom_powersave_cpu_gov" ] && echo "interactive" > "$basedir/custom_powersave_cpu_gov"
}

check_kernel_dirs() {
    [ -d /sys/kernel/ged/hal ] && { CHIPSET_ID=1; return 0; }
    [ -d /sys/class/kgsl/kgsl-3d0/devfreq ] && { CHIPSET_ID=2; return 0; }
    [ -d /sys/devices/platform/kgsl-2d0.0/kgsl ] && { CHIPSET_ID=2; return 0; }
    return 1
}

fetch_soc_properties() {
    local soc_props="ro.board.platform ro.soc.model ro.hardware ro.hardware.chipname"
    for prop in $soc_props; do
        getprop "$prop"
    done
}

parse_soc_string() {
    case "$1" in
        *Qualcomm* | *sdm* | *qcom* | *SDM* | *QCOM*) CHIPSET_ID=2 ;;
        *Exynos* | *exynos* | *samsung* | *universal* | *erd* | *s5e*) CHIPSET_ID=3 ;;
        *MediaTek* | *mt* | *MT*) CHIPSET_ID=1 ;;
        *Unisoc* | *unisoc* | *ums*) CHIPSET_ID=4 ;;
        *Tensor* | *tensor* | *gs101* | *google* | *GS101* | *Google*) CHIPSET_ID=5 ;;
    esac
}

identify_chipset() {
    print_status "Identifying device chipset..."
    check_kernel_dirs
    [ $CHIPSET_ID -eq 0 ] && parse_soc_string "$(grep -E "Hardware|Processor" /proc/cpuinfo | uniq | cut -d ':' -f 2 | sed 's/^[ \t]*//')"
    [ $CHIPSET_ID -eq 0 ] && parse_soc_string "$(fetch_soc_properties)"

    case "$CHIPSET_ID" in
        1) ui_print "- Chipset identified as MediaTek" ;;
        2) ui_print "- Chipset identified as Snapdragon" ;;
        3) ui_print "- Chipset identified as Exynos" ;;
        4) ui_print "- Chipset identified as Unisoc" ;;
        5) ui_print "- Chipset identified as Google Tensor" ;;
        *)
          ui_print "! Unrecognized SoC, applying universal settings."
          ui_print "! Thinking this wrong? Ask to maintainer."
          CHIPSET_ID=0
          ;;
    esac
    echo "$CHIPSET_ID" > "$basedir/soc"
}

extract_and_place_files() {
    print_status "Extracting module files..."
    safe_extract 'gamelist.json' "$basedir"
    safe_extract 'addon/vmt' "$basedir"
    safe_extract 'webroot/*' "$MODPATH"
    safe_extract 'stellar_icon.png' "/data/local/tmp"
    safe_extract 'service/*' "$MODPATH"
    safe_extract 'common/*' "$MODPATH"
    safe_extract 'system/*' "$MODPATH"
    safe_extract 'service.sh' "$MODPATH"
    safe_extract 'post-fs-data.sh' "$MODPATH"
    safe_extract 'system.prop' "$MODPATH"
}

handle_binaries() {
    print_status "Setting up binaries..."
    local binaries="stellars profiles_mode vmt zeta_tweak tensor_detect tensor_optimizer mali_g78_optimizer f2fs_optimizer thermal_tensor display_optimizer tensor_g1"
    
    if $USE_SYMLINK; then
        print_status "Setting up symlinks for binaries..."
        for bin_name in $binaries; do
            cp "$MODPATH/system/bin/$bin_name" "$CUSTOM_BIN_PATH/"
            chmod 755 "$CUSTOM_BIN_PATH/$bin_name"
            ln -sf "$CUSTOM_BIN_PATH/$bin_name" "$MODPATH/system/bin/$bin_name"
        done
    else
        for bin_name in $binaries; do
            chmod 755 "$MODPATH/system/bin/$bin_name"
        done
    fi
}

set_permissions() {
    print_status "Setting permissions..."
    set_perm_recursive "$MODPATH" 0 0 0755 0644
    
    if $USE_SYMLINK; then
        set_perm_recursive "$CUSTOM_BIN_PATH" 0 2000 0755 0755
    fi
    set_perm_recursive "$MODPATH/system/bin" 0 2000 0755 0755
    
    chmod +x "$basedir/vmt"
}

finalize_installation() {
    print_status "Cleaning up..."
    rm -f "$MODPATH/verify.sh" "$MODPATH/LICENSE"
    find "$MODPATH" -name "*.sha256" -delete 2>/dev/null

    RAND_MSG=$((RANDOM % 5 + 1))
    case $RAND_MSG in
      1)  print_status "Let the light appear !" ;;
      2)  print_status "The Stellar waits." ;;
      3)  print_status "Light Stellar Glow." ;;
      4)  print_status "Comet Stellar Flying." ;;
      5)  print_status "Feed Me Donate Wen." ;;
    esac
    
    ui_print "- Join our channel for updates!"
    sleep 0.5
    am start -a android.intent.action.VIEW -d "https://t.me/hosshi_prjkt" > /dev/null 2>&1

    ui_print "*******************************"
    ui_print " Installation successful!"
    ui_print "*******************************"
}

detect_root_method
setup_directories_and_configs
create_essential_files
identify_chipset
extract_and_place_files
handle_binaries
set_permissions
finalize_installation