#!/bin/bash
# RuslanOS — Build Full ROM
# Собирает LineageOS + RuslanOS из исходников
#
# Использование:
#   ./build-full-rom.sh              # интерактивный режим
#   ./build-full-rom.sh --device <x> # билд для конкретного устройства
#   ./build-full-rom.sh --gsi        # сборка GSI (Generic System Image)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$HOME/ruslanos-build"
RUSLANOS_SOURCE="$PROJECT_DIR"
DEVICE=""
BUILD_GSI=false
WITH_GAPPS=false

# Парсинг аргументов
while [[ $# -gt 0 ]]; do
  case "$1" in
    --device) DEVICE="$2"; shift 2 ;;
    --gsi) BUILD_GSI=true; shift ;;
    --gapps) WITH_GAPPS=true; shift ;;
    *) echo "Неизвестный аргумент: $1"; exit 1 ;;
  esac
done

echo "🛡 RuslanOS — Сборка прошивки"
echo "==============================="

# 1. Инициализация репозитория
if [ ! -d "$BUILD_DIR/.repo" ]; then
  echo "[1/6] Инициализация репозитория LineageOS 22.2..."
  mkdir -p "$BUILD_DIR"
  cd "$BUILD_DIR"
  repo init -u https://github.com/LineageOS/android.git -b lineage-22.2
else
  echo "[1/6] Репозиторий уже инициализирован"
  cd "$BUILD_DIR"
fi

# 1b. Локальный манифест для RuslanOS
echo "[2/6] Добавление RuslanOS в манифест..."
mkdir -p .repo/local_manifests
cat > .repo/local_manifests/ruslanos.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project path="packages/apps/RuslanShell"
           name="valldun1/RuslanOS"
           remote="github"
           revision="main" />
</manifest>
EOF

# 2. Синхронизация исходников
echo "[3/6] Синхронизация исходников (это займёт время)..."
repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc 2>/dev/null || echo 4)

# 3. Настройка device tree
if [ "$BUILD_GSI" = true ]; then
  echo "[4/6] Сборка GSI (Generic System Image)..."
  export TARGET_PRODUCT=aosp_arm64
  export TARGET_BUILD_VARIANT=userdebug
else
  echo "[4/6] Настройка device tree: $DEVICE"
  # Здесь должен быть device tree
  # Пример: source build/envsetup.sh && lunch lineage_${DEVICE}-userdebug
fi

# 4. Запуск сборки
echo "[5/6] Запуск сборки..."
source build/envsetup.sh

if [ "$BUILD_GSI" = true ]; then
  lunch aosp_arm64-userdebug
  mka systemimage -j$(nproc 2>/dev/null || echo 4)
else
  lunch "lineage_${DEVICE}-userdebug"
  mka bacon -j$(nproc 2>/dev/null || echo 4)
fi

echo "[6/6] Сборка завершена!"
echo ""
echo "📦 Образ: $BUILD_DIR/out/target/product/${DEVICE:-generic}/"
ls -lh "$BUILD_DIR/out/target/product/${DEVICE:-generic}/"*.img 2>/dev/null || \
  ls -lh "$BUILD_DIR/out/target/product/${DEVICE:-generic}/"*.zip 2>/dev/null || \
  echo "   (файлы не найдены — проверь директорию out)"
