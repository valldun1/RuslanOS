# Внесение изменений в RuslanOS

RuslanOS — open-source проект. Любой может форкнуть, модифицировать и собрать свою версию.

## Структура репозитория

```
RuslanOS/
├── ruslan-shell/           # Лаунчер (Kotlin + Jetpack Compose)
│   └── app/src/main/java/com/ruslanos/shell/
│       ├── MainActivity.kt
│       └── ui/
│           ├── RuslanOSApp.kt    # Основной UI (сплеш, чат)
│           └── theme/Theme.kt    # Тёмная тема
├── ruslanos-module/        # Magisk-модуль
│   ├── module.prop
│   ├── customize.sh
│   └── system/etc/init/ruslanos.rc  # Автозапуск агента
├── docs/                   # Документация
│   └── INSTALL.md
├── phases/                 # Фазы разработки (Fazovyj Perehod)
│   ├── 00-context.md
│   ├── 01-goal.md
│   └── 02-plan.md
├── .github/workflows/      # CI/CD
├── PLAN.md                 # Общий план
├── README.md               # Описание проекта
└── LICENSE                 # Apache 2.0
```
