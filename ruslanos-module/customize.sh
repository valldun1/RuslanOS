#!/system/bin/sh

# RuslanOS Setup — Magisk Module
# Установка Ruslan Agent в /system/priv-app

MODDIR=${0%/*}

# Создаём директорию для агента
mkdir -p /system/priv-app/RuslanAgent

# Копируем APK агента (устанавливается модулем)
cp -f "$MODDIR/system/priv-app/RuslanAgent/RuslanAgent.apk" /system/priv-app/RuslanAgent/
chmod 644 /system/priv-app/RuslanAgent/RuslanAgent.apk

# Блокируем стоковые приложения (создаём .replace)
for app in "Mms" "Email" "Calendar" "Calculator" "DeskClock" "SoundRecorder" "Music" "Video" "Stk" "Browser" "QuickSearchBox"; do
  mkdir -p "/system/priv-app/$app"
  touch "/system/priv-app/$app/.replace"
done

# Настройки системы
setprop persist.sys.launcher.package com.ruslanos.shell

# Лог
echo "[RuslanOS] Module installed at $(date)" >> /cache/ruslanos_setup.log
