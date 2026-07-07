#!/bin/bash
# RuslanOS — Setup Build Environment
# Настраивает среду для сборки LineageOS / RuslanOS
# Поддерживает: macOS (OrbStack/UTM), Linux, HES

set -e

echo "🛡 RuslanOS — Настройка билд-среды"
echo "====================================="

# Определяем ОС
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin)
    echo "[*] macOS detected ($ARCH)"

    # Проверяем OrbStack или Docker
    if command -v orb &>/dev/null; then
      echo "[✓] OrbStack найден"
      echo "[*] Запускаем Ubuntu контейнер..."
      orb run ubuntu -- bash -c "
        apt update && apt install -y bc bison build-essential ccache \
          flex g++-multilib gcc-multilib git gnupg gperf imagemagick \
          lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool \
          libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils \
          lzop pngcrush rsync schedtool squashfs-tools xsltproc zip \
          zlib1g-dev libc6-dev-i386 lib32stdc++6 android-sdk-libsparse-utils
        echo '[✓] Зависимости установлены'
      "
    elif command -v docker &>/dev/null; then
      echo "[*] Docker найден, создаём образ..."
      docker run -it --rm -v $(pwd):/ruslanos ubuntu:22.04 bash
    else
      echo "[!] Установи OrbStack (рекомендуется) или Docker"
      echo "    brew install orbstack"
      echo "    или https://orbstack.dev"
      exit 1
    fi
    ;;

  Linux)
    echo "[*] Linux detected ($ARCH)"
    if [ -f /etc/debian_version ]; then
      echo "[*] Debian/Ubuntu — устанавливаю зависимости..."
      sudo apt update
      sudo apt install -y bc bison build-essential ccache curl flex \
        g++-multilib gcc-multilib git gnupg gperf imagemagick \
        lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool \
        libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev \
        libxml2 libxml2-utils lzop pngcrush rsync schedtool \
        squashfs-tools xsltproc zip zlib1g-dev
    elif [ -f /etc/arch-release ]; then
      echo "[*] Arch — устанавливаю зависимости..."
      sudo pacman -S --needed base-devel git python ccache lzop xmlto
    else
      echo "[!] Неизвестный дистрибутив Linux. Установи зависимости вручную."
      exit 1
    fi

    # Настройка repo
    if ! command -v repo &>/dev/null; then
      echo "[*] Устанавливаю repo..."
      mkdir -p ~/bin
      curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
      chmod a+x ~/bin/repo
      export PATH=~/bin:$PATH
      echo 'export PATH=~/bin:$PATH' >> ~/.bashrc
    fi
    ;;

  *)
    echo "[!] Неподдерживаемая ОС: $OS"
    exit 1
    ;;
esac

# Настройка ccache
echo "[*] Настройка ccache..."
ccache -M 50G
echo 'export USE_CCACHE=1' >> ~/.bashrc
echo 'export CCACHE_EXEC=/usr/bin/ccache' >> ~/.bashrc

echo ""
echo "✅ Билд-среда готова!"
echo "   Далее: source build/envsetup.sh && lunch ruslanos_<device>-userdebug && mka bacon"
