#!/bin/bash
# RuslanOS — Sign OTA Package
# Подписывает OTA-обновления для RuslanOS

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KEY_DIR="${SCRIPT_DIR}/../keys"

echo "🛡 RuslanOS — Подпись OTA"
echo "=========================="

# 1. Проверка ключей
if [ ! -d "${KEY_DIR}" ]; then
  echo "[*] Создание ключей подписи..."
  mkdir -p "${KEY_DIR}"

  # Генерация ключей для OTA
  subject="/C=RU/ST=Moscow/L=Moscow/O=RuslanOS/OU=Dev/CN=RuslanOS"

  for key in releasekey platform shared media networkstack; do
    if [ ! -f "${KEY_DIR}/${key}.pk8" ]; then
      echo "  Генерация ${key}..."
      openssl genrsa -out "${KEY_DIR}/${key}.pem" 4096
      openssl pkcs8 -topk8 -inform PEM -outform DER -in "${KEY_DIR}/${key}.pem" \
        -out "${KEY_DIR}/${key}.pk8" -nocrypt
      openssl req -new -x509 -key "${KEY_DIR}/${key}.pem" \
        -out "${KEY_DIR}/${key}.x509.pem" -days 3650 -subj "${subject}"
    fi
  done
  echo "[✓] Ключи созданы"
else
  echo "[✓] Ключи найдены"
fi

# 2. Подпись OTA
if [ -f "$1" ]; then
  echo "[*] Подпись OTA-пакета: $1"
  java -jar "${SCRIPT_DIR}/signapk.jar" \
    "${KEY_DIR}/releasekey.x509.pem" \
    "${KEY_DIR}/releasekey.pk8" \
    "$1" "$1.signed"
  echo "[✓] Подписано: $1.signed"
else
  echo "Использование: $0 <ota-пакет.zip>"
  exit 1
fi
