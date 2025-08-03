#!/system/bin/sh

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

# This script will be executed in post-fs-data mode

# Set up Stellar Tweaks directories and initial configuration
basedir="/data/adb/.config/stellar"

# Ensure directories exist
mkdir -p "$basedir"

# Set up initial configuration if not exists
[ ! -f "$basedir/soc" ] && echo "0" > "$basedir/soc"

# Log post-fs-data execution
echo "Stellar Tweaks post-fs-data executed at $(date)" >> "$basedir/stellar.log"