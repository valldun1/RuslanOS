#!/bin/bash
# RuslanOS — Device Check
# Проверяет совместимость устройства с RuslanOS (Treble, A/B, архитектура)

set -e

echo "🛡 RuslanOS — Проверка устройства"
echo "=================================="
echo ""

# Эти проверки выполняются на самом устройстве (через ADB или терминал)
if [ -f /system/build.prop ]; then
  echo "[1/4] Основная информация:"
  echo "  Модель:     $(getprop ro.product.model 2>/dev/null || echo 'N/A')"
  echo "  Производитель: $(getprop ro.product.manufacturer 2>/dev/null || echo 'N/A')"
  echo "  Android:    $(getprop ro.build.version.release 2>/dev/null || echo 'N/A')"
  echo "  API:        $(getprop ro.build.version.sdk 2>/dev/null || echo 'N/A')"
  echo "  Архитектура: $(getprop ro.product.cpu.abi 2>/dev/null || echo 'N/A')"
  echo ""

  echo "[2/4] Проверка Project Treble:"
  if [ -n "$(getprop ro.treble.enabled 2>/dev/null)" ]; then
    echo "  ✅ Treble: $(getprop ro.treble.enabled)"
  else
    # Treble включён для API 26+ (Android 8+)
    if [ "$(getprop ro.build.version.sdk)" -ge 26 ] 2>/dev/null; then
      echo "  ✅ Treble: включён (Android 8+)"
    else
      echo "  ❌ Treble: НЕ поддерживается"
    fi
  fi

  echo ""
  echo "[3/4] Проверка A/B (seamless updates):"
  SLOT=$(getprop ro.boot.slot_suffix 2>/dev/null || echo "")
  if [ -n "$SLOT" ]; then
    echo "  ✅ A/B: да (текущий слот: $SLOT)"
    AB="_ab"
  else
    echo "  ℹ️ A/B: нет (A-only)"
    AB=""
  fi

  echo ""
  echo "[4/4] Проверка bootloader:"
  if [ "$(getprop ro.boot.locked 2>/dev/null)" = "0" ] || [ "$(getprop ro.boot.verifiedbootstate 2>/dev/null)" = "orange" ]; then
    echo "  ✅ Bootloader: разблокирован"
  else
    echo "  ❌ Bootloader: заблокирован (нужна разблокировка)"
  fi

  echo ""
  echo "📋 Резюме для RuslanOS:"
  echo "  Устройство готово к GSI: $(getprop ro.build.version.sdk -ge 26 2>/dev/null && echo '✅' || echo '❌')"
  echo "  Тип GSI: arm64${AB}"
else
  echo "⚠️ Это не Android-устройство или нет доступа к build.prop"
  echo "   Запусти скрипт на устройстве через ADB:"
  echo "   adb shell sh scripts/device-check.sh"
fi
