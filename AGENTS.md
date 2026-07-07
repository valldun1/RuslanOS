# AGENTS.md — RuslanOS

Этот файл — инструкция для AI-агентов (Hermes, Claude Code, Codex), работающих над проектом RuslanOS.

## Проект

**RuslanOS** — минимальная AI-first операционная система на базе LineageOS (Android 15).
Единственный интерфейс — Ruslan Agent. Пользователь модифицирует ОС через агента.

## Структура репозитория

```
RuslanOS/
├── ruslan-shell/            ← Лаунчер (Kotlin + Jetpack Compose)
│   └── app/src/main/java/com/ruslanos/shell/
│       ├── MainActivity.kt  ← Splash → Chat
│       ├── CommandProcessor.kt  ← Shell-команды Руслана
│       ├── VoiceInputHandler.kt ← Голосовой ввод (заготовка)
│       └── ui/RuslanOSApp.kt   ← Compose UI
├── ruslanos-module/         ← Magisk-модуль
│   ├── customize.sh         ← Пост-установка
│   ├── service.sh           ← Автозапуск
│   ├── uninstall.sh
│   └── system/              ← Файлы для /system
├── scripts/                 ← Скрипты сборки
├── docs/                    ← Документация
├── phases/                  ← Фазы разработки
└── .github/workflows/       ← CI/CD
```

## Текущий статус

- **MVP фаза:** GSI + Magisk прототип
- **Статус сборки:** GitHub Actions собирает APK и модуль
- **Ожидание:** модель устройства от Valentin для тестирования

## Коммуникация

- Valentin (Кэп) — Telegram DM
- Предпочтения: короткие команды, без лишних объяснений
- Решения: предложить 1-3 варианта, он выбирает
- Git: commit после каждой фазы, push сразу

## Build & Test

```bash
# Собрать Magisk-модуль
cd ruslanos-module && zip -r ../out/ruslanos-setup.zip .

# Проверить shell-скрипты
bash -n scripts/*.sh
bash -n ruslanos-module/*.sh
```

## Github

- Репозиторий: valldun1/RuslanOS
- Ветка: main (все изменения — в main)
- CI: GitHub Actions (build-ruslanshell.yml)
- Releases: по тегам v*
