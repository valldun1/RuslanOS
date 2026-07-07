# Сборка RuslanOS из исходников

## Быстрый старт (GSI + Magisk)

Этот метод не требует сборки ROM — используется готовый образ LineageOS GSI.

### Шаг 1: Окружение

Любой компьютер с:
- `adb` и `fastboot`
- `wget` или `curl`

### Шаг 2: Скачать GSI

```bash
# LineageOS 22.2 GSI (ARM64 + A-only, без GApps)
wget https://sourceforge.net/projects/lineageos-gsi/files/22/lineage-22.2-*-arm64_bvN.img

# Для A/B устройств:
wget https://sourceforge.net/projects/lineageos-gsi/files/22/lineage-22.2-*-arm64_bvN.img
```

Актуальные ссылки — на https://sourceforge.net/projects/lineageos-gsi/

### Шаг 3: Прошивка

```bash
# Переведи устройство в fastboot:
adb reboot bootloader
# или выключи и зажми VolDown+Power

# Для A-only:
fastboot flash system lineage-22.2-*-arm64_bvN.img

# Для A/B:
fastboot flash system lineage-22.2-*-arm64_bvN.img

fastboot -w
fastboot reboot
```

### Шаг 4: Установка Magisk

1. Скачай Magisk Manager APK
2. `adb install Magisk-*.apk`
3. Открой на телефоне → Установить → Прямая установка

### Шаг 5: Установка RuslanOS модуля

```bash
# Сборка модуля из исходников
cd ruslanos-module
zip -r ../out/ruslanos-setup-v0.1.0.zip .

# Закинь zip на телефон и установи через Magisk Manager
# Или через adb:
adb push out/ruslanos-setup-v0.1.0.zip /sdcard/
```

## Полная сборка ROM (продвинутый метод)

Требуется: Linux (Ubuntu 22.04+), 32+ GB RAM, 300+ GB SSD, мощный интернет.

### Шаг 1: Билд-среда

```bash
# На Mac Mini через OrbStack:
bash scripts/setup-build-env.sh

# Или вручную на Ubuntu:
sudo apt update && sudo apt install -y bc bison build-essential ccache curl flex \
  g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev \
  lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev \
  libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync \
  schedtool squashfs-tools xsltproc zip zlib1g-dev
```

### Шаг 2: Инициализация

```bash
mkdir -p ~/ruslanos-build && cd ~/ruslanos-build
repo init -u https://github.com/LineageOS/android.git -b lineage-22.2
```

### Шаг 3: Добавление RuslanOS

```bash
mkdir -p .repo/local_manifests
cat > .repo/local_manifests/ruslanos.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote name="ruslanos" fetch="https://github.com/valldun1/" />
  <project path="packages/apps/RuslanOS" name="RuslanOS" remote="ruslanos" revision="main" />
</manifest>
EOF
```

### Шаг 4: Синхронизация

```bash
repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc)
```

### Шаг 5: Сборка

```bash
source build/envsetup.sh
lunch lineage_<device>-userdebug
mka bacon -j$(nproc)
```

### Шаг 6: Прошивка

```bash
cd out/target/product/<device>/
fastboot flash boot boot.img
fastboot flash dtbo dtbo.img
fastboot flash vendor vendor.img
fastboot flash system system.img
fastboot -w
fastboot reboot
```

## GitHub Actions CI

При пуше в `main` GitHub Actions автоматически:
1. Собирает RuslanShell APK
2. Собирает Magisk-модуль zip
3. Загружает артефакты

Скачать готовые сборки: [Actions → Latest](https://github.com/valldun1/RuslanOS/actions)
