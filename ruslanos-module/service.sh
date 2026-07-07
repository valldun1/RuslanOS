#!/system/bin/sh

# RuslanOS — Service Script
# Запускается Magisk после загрузки системы
# Отвечает за автозапуск Ruslan Agent и фоновые сервисы

MODDIR=${0%/*}

# Ждём завершения загрузки Android
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 2
done

# Даём системе ещё 5 секунд на инициализацию
sleep 5

# Запускаем Ruslan Agent как системное приложение
if [ -f /system/priv-app/RuslanAgent/RuslanAgent.apk ]; then
  am start -n com.ruslan.agent/.MainActivity
  log -t "RuslanOS" "[✓] Ruslan Agent запущен"
else
  log -t "RuslanOS" "[✗] RuslanAgent.apk не найден в /system/priv-app/"
fi

# Применяем системные твики (если не были применены в customize.sh)
resetprop persist.sys.launcher.package com.ruslanos.shell 2>/dev/null
resetprop persist.sys.launcher.package com.ruslanos.shell 2>/dev/null

log -t "RuslanOS" "[✓] RuslanOS загружена"
