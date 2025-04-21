#!/bin/bash

set -e

INSTALL_DIR="/opt/dynamic-mobsf"
ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip"
ANDROID_SDK_DIR="$INSTALL_DIR/android-sdk"
AVD_NAME="dummy28"
ANDROID_API=28
MOBSF_REPO="https://github.com/MobSF/Mobile-Security-Framework-MobSF.git"
MOBSF_DIR="$INSTALL_DIR/Mobile-Security-Framework-MobSF"
FRIDA_SERVER_ZIP_URL="https://github.com/dword32bit/dynamic-mobsf/releases/download/frida/frida-server.zip"
FRIDA_SERVER_ZIP="$INSTALL_DIR/assets/frida-server.zip"

if [ "$EUID" -ne 0 ]; then
  echo "[!] Please run as root"
  exit 1
fi

echo "[+] Creating base directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR/assets"
cd "$INSTALL_DIR"

echo "[+] Installing system dependencies..."
apt-get update && apt-get install -y \
    unzip openjdk-11-jdk python3 python3-pip git wget curl libvirt-daemon-system \
    qemu-kvm libvirt-clients bridge-utils virt-manager python3-venv libc6-i386 lib32stdc++6 lib32gcc-s1 lib32ncurses6 lib32z1

echo "[+] Installing poetry..."
if ! command -v poetry &> /dev/null; then
  curl -sSL https://install.python-poetry.org | python3 -
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "[+] Downloading Android command line tools..."
mkdir -p "$ANDROID_SDK_DIR/cmdline-tools"
cd "$ANDROID_SDK_DIR/cmdline-tools"
wget -q "$ANDROID_SDK_URL" -O cmdline-tools.zip
unzip -q cmdline-tools.zip
mv cmdline-tools latest

export ANDROID_HOME="$ANDROID_SDK_DIR"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

echo "[+] Accepting SDK licenses and installing SDK packages..."
yes | sdkmanager --licenses
sdkmanager "platform-tools" "emulator" \
           "system-images;android-$ANDROID_API;google_apis;x86_64" \
           "platforms;android-$ANDROID_API"

echo "[+] Creating AVD: $AVD_NAME"
echo "no" | avdmanager create avd -n "$AVD_NAME" -k "system-images;android-$ANDROID_API;google_apis;x86_64" --force

echo "[+] Cloning MobSF..."
git clone "$MOBSF_REPO" "$MOBSF_DIR"
cd "$MOBSF_DIR"
poetry install

echo "[+] Downloading frida-server..."
curl -L "$FRIDA_SERVER_ZIP_URL" -o "$FRIDA_SERVER_ZIP"
unzip -q "$FRIDA_SERVER_ZIP" -d "$INSTALL_DIR/frida"
chmod +x "$INSTALL_DIR/frida/frida-server"

echo "[+] Creating run script..."
sudo wget https://github.com/dword32bit/dynamic-mobsf/releases/download/frida/run_mobsf.sh -O /opt/dynamic-mobsf/run_mobsf.sh

chmod +x "$INSTALL_DIR/run_mobsf.sh"

echo "[✅] Setup complete! Run this to start MobSF + Emulator:"
echo "bash $INSTALL_DIR/run_dynamic_mobsf.sh"
