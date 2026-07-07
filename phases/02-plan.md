# Фаза 1 — План: полная подготовка RuslanOS к утру

## Что нужно сделать за ночь

### Фаза 2a — Gradle wrapper + лаунчер (0.5-1 час)
- [x] Написать MainActivity.kt (Splash → Chat)
- [x] Написать RuslanOSApp.kt (Compose UI — тёмная тема, чат, команды)
- [x] Написать Theme.kt
- [x] AndroidManifest.xml с HOME категорией + Lock Task Mode
- [ ] Сгенерировать gradlew (gradle wrapper) — **нужно для CI**
- [ ] Проверить сборку через GitHub Actions (пуш → билд)
- [ ] Создать Kotlin-классы: CommandProcessor (обработчик команд Руслана)
- [ ] Создать VoiceInputHandler (голосовой ввод)

### Фаза 2b — Magisk-модуль полный (0.5-1 час)
- [x] module.prop
- [x] customize.sh (стандортный)
- [ ] Создать служебные скрипты:
  - [ ] `system/bin/ruslan` — CLI-команда для вызова Руслана из терминала
  - [ ] `system/etc/init/ruslanos.rc` — автозапуск агента при загрузке
  - [ ] `service.sh` — Magisk-сервис для фонового запуска
  - [ ] `uninstall.sh` — очистка при удалении модуля
- [ ] Создать `META-INF/com/google/android/update-binary` (стандартный Magisk)
- [ ] Создать `META-INF/com/google/android/updater-script`
- [ ] README для модуля
- [ ] Тестовый стенд: APK-заглушка RuslanAgent

### Фаза 2c — Скрипты сборки ROM (1-2 часа)
- [ ] `scripts/build-gsi.sh` — авто-загрузка GSI + наши патчи
- [ ] `scripts/setup-build-env.sh` — развёртывание билд-среды (OrbStack, Ubuntu, repo)
- [ ] `scripts/build-full-rom.sh` — полная сборка LineageOS + RuslanOS
- [ ] `scripts/sign-ota.sh` — подпись OTA-пакетов
- [ ] `scripts/device-check.sh` — проверка Treble-совместимости устройства
- [ ] `Makefile` — общие команды (make gsi, make rom, make flash)

### Фаза 2d — Документация (1 час)
- [x] INSTALL.md
- [x] CONTRIBUTING.md
- [ ] `docs/DEVICE-SUPPORT.md` — какие устройства поддерживаются, Treble check
- [ ] `docs/ARCHITECTURE.md` — подробная архитектура системы
- [ ] `docs/BUILD-FROM-SOURCE.md` — сборка из исходников
- [ ] `docs/COMMANDS.md` — какие команды понимает Руслан в ОС
- [ ] `docs/TESTING.md` — как тестировать прошивку
- [ ] `docs/ROADMAP.md` — дорожная карта проекта

### Фаза 2e — CI/CD полный (0.5 часа)
- [x] GitHub Actions: build APK
- [ ] GitHub Actions: release on tag
- [ ] GitHub Actions: lint + syntax check
- [ ] GitHub Actions: build Magisk module zip
- [ ] `scripts/ci-build.sh` — локальный CI-скрипт

### Фаза 2f — Управление проектом
- [ ] Настроить `AGENTS.md` / `CLAUDE.md` — инструкции для AI-агентов
- [ ] Настроить GitHub Issues шаблоны
- [ ] Создать GitHub Wiki страницы

## Технические детали

### Gradle wrapper
Нужен `gradlew` чтобы GitHub Actions мог собрать APK.
Создаётся через `gradle wrapper` — но на Termux нет Gradle.
Альтернатива: скачать gradle-wrapper.jar вручную и создать `gradlew` скрипт.

### Magisk модуль
Стандартная структура:
```
ruslanos-module/
├── META-INF/com/google/android/
│   ├── update-binary
│   └── updater-script
├── module.prop
├── customize.sh
├── service.sh
├── uninstall.sh
└── system/
    ├── priv-app/RuslanAgent/RuslanAgent.apk
    ├── bin/ruslan
    └── etc/init/ruslanos.rc
```

### CI Pipeline
- Push → GitHub Actions
- Step 1: Setup JDK 17 + Gradle
- Step 2: Build release APK
- Step 3: Build Magisk module zip (включает APK)
- Step 4: Upload artifacts
- Step 5: On tag → GitHub Release
