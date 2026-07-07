# RuslanOS Setup — Magisk Module

**Version:** 0.1.0
**Author:** Ruslan Team

## Что делает

Устанавливает **Ruslan Agent** в `/system/priv-app` и превращает обычный Android в **RuslanOS** — минимальную AI-операционную систему.

## Установка

1. Скачай `ruslanos-setup-v0.1.0.zip`
2. Открой Magisk Manager → Модули → Установить из ZIP
3. Выбери zip-файл
4. Перезагрузи устройство

## Состав модуля

```
system/
├── priv-app/RuslanAgent/   ← Ruslan Agent (системное приложение)
├── bin/ruslan              ← CLI-команда для терминала
└── etc/init/ruslanos.rc    ← Init-скрипт автозапуска
```

## После установки

- Ruslan Agent запускается при каждой загрузке
- CLI-команда `ruslan` доступна из терминала/ADB
- Стоковые приложения блокируются (Mms, Email, Browser и др.)

## Удаление

Через Magisk Manager или установкой `uninstall.sh`

## Требования

- Magisk 24.0+
- Android 8.0+ (Project Treble)
- ARM64 устройство
