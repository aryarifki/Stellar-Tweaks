#!/bin/sh

#
# Copyright (C) 2024-2025 Kanao
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Files to remove
rm -f /data/local/tmp/Trinity_icon.png /data/stellar

# Don't Let Any Cache/Empty/Traced/Garbage/Whatever
BINS="util_func function_addon trinitys_dfc profiles_mode"
for DIR in /data/adb/*/bin; do
    [ -d "$DIR" ] && for BIN in $BINS; do
        rm -f "$DIR/$BIN"
    done
done

# Resetting Default Value
su -c "cmd settings reset global"
su -c "cmd settings reset secure"
su -c "cmd settings reset system"

# Revert Intent Activity
su -c "pm enable com.google.android.gms/.chimera.GmsIntentOperationService"
su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"