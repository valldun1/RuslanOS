#!/bin/bash
# RuslanOS — Build GSI with Integrated Ruslan Agent
# Скачивает LineageOS GSI, патчит и упаковывает с RuslanOS компонентами
#
# Использование:
#   ./build-gsi.sh              # скачать и собрать
#   ./build-gsi.sh --local path # патчить локальный GSI

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/../out"
GSI_DIR="${OUTPUT_DIR}/gsi"
DOWNLOAD_DIR="${GSI_DIR}/download"

mkdir -p "${DOWNLOAD_DIR}" "${GSI_DIR}"

echo "🛡 RuslanOS — Сборка GSI"
echo "========================="

# Параметры
GSI_VERSION="lineage-22.2"
GSI_TYPE="arm64_bvN"  # arm64 + A-only + vanilla (no GApps)
LINEAGEOS_GSI_URL="https://sourceforge.net/projects/lineageos-gsi/files/22/"

# 1. Выбор источника
if [ "$1" = "--local" ] && [ -n "$2" ]; then
  echo "[*] Использую локальный GSI: $2"
  GSI_SOURCE="$2"
else
  echo "[1/4] Скачивание LineageOS GSI..."
  echo "    Источник: ${LINEAGEOS_GSI_URL}"
  echo "    Ищем последнюю версию ${GSI_VERSION}-*.img"

  # Скачиваем GSI (пользователь указывает точную ссылку или мы парсим)
  # Пока — инструкция для ручного скачивания
  cat << EOF
  ⚠️ Авто-ссылка может меняться.
  Скачай GSI вручную или укажи --local <путь к .img>:

  1. Открой ${LINEAGEOS_GSI_URL}
  2. Найди последний ${GSI_VERSION}-*-${GSI_TYPE}.img
  3. Скачай: wget <url> -O ${DOWNLOAD_DIR}/${GSI_VERSION}.img
  4. Запусти: $0 --local ${DOWNLOAD_DIR}/${GSI_VERSION}.img
EOF
  exit 0
fi

# 2. Распаковка и патчинг
echo "[2/4] Распаковка GSI..."
IMG_FILE="${GSI_SOURCE}"

if [ ! -f "${IMG_FILE}" ]; then
  echo "❌ Файл не найден: ${IMG_FILE}"
  exit 1
fi

echo "[3/4] Интеграция RuslanOS компонентов..."
# Здесь будет: монтирование system.img, добавление RuslanAgent, упаковка обратно
# Пока — инструкция
cat << EOF
  🔧 Интеграция включает:
    - Ruslan Agent → /system/priv-app/RuslanAgent/
    - RuslanShell → /system/priv-app/RuslanShell/
    - init скрипты → /system/etc/init/
    - CLI → /system/bin/ruslan
    - Magisk pre-patched

  Полная автоматизация — в разработке.
  Сейчас: устанавливай LineageOS GSI → Magisk → наш модуль.
EOF

# 4. Вывод
echo "[4/4] Готово!"
echo ""
echo "📦 Исходный GSI: ${IMG_FILE}"
echo "📋 Далее: fastboot flash system ${IMG_FILE}"
echo "📋 Затем: fastboot -w && fastboot reboot"
echo "📋 Установи Magisk и модуль ruslanos-setup"
