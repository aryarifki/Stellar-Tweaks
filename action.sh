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

    # Try simple KSU WebUI Standalone First
    if pm path com.dergoogler.mmrl.wx >/dev/null 2>&1; then
        echo "[*] Start Open WebUI on KSU Webui Standanlone.."
        am start -n "com.dergoogler.mmrl.wx/.ui.activity.webui.WebUIActivity" -e id "stellar" > /dev/null 2>&1
        exit 0
    fi
    
    if pm path com.dergoogler.mmrl >/dev/null 2>&1; then
        echo "[*] Starting WebUI through MMRL..."
        am start -n "com.dergoogler.mmrl/.ui.activity.webui.WebUIActivity" -e MOD_ID "stellar" > /dev/null 2>&1
        exit 0
    fi

# Case didn't have, Download manually
echo "[!] KsuWebUI is required for access feature.."
echo "[!] Without WebUI you lost many feature.."
sleep 0.5
echo "[*] Try Open Intent.."
echo "[*] Opening download page..."
am start -a android.intent.action.VIEW -d "https://github.com/5ec1cff/KsuWebUIStandalone/releases" > /dev/null 2>&1

exit 0