#!/system/bin/sh

# RuslanOS — Uninstall Script
# Запускается при удалении модуля через Magisk Manager

MODDIR=${0%/*}

# Удаляем Ruslan Agent из system
rm -rf /system/priv-app/RuslanAgent 2>/dev/null

# Удаляем CLI-команду
rm -f /system/bin/ruslan 2>/dev/null

# Удаляем init-скрипт
rm -rf /system/etc/init/ruslanos.rc 2>/dev/null

# Восстанавливаем стандартный лаунчер (если был изменён)
resetprop -n persist.sys.launcher.package "" 2>/dev/null

# Лог
echo "[RuslanOS] Модуль удалён" >> /cache/ruslanos_uninstall.log

exit 0
