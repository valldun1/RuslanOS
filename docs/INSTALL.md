# Установка RuslanOS (прототип GSI + Magisk)

## Требования
- Устройство с **разблокированным bootloader**
- **Project Treble** поддержка (Android 8+)
- **fastboot** на компьютере
- **Magisk** (установленный)

## Шаг 1 — Разблокировка bootloader

### Xiaomi
1. Привяжи Mi Account в настройках
2. Запроси разблокировку через Community или Mi Unlock
3. Скачай Mi Unlock Tool (Windows) — запусти через Wine если на Mac
4. `fastboot oem unlock` или через Mi Unlock

### Другие устройства
- Google Pixel: `fastboot oem unlock`
- OnePlus: `fastboot oem unlock`
- Samsung: Odin + патченный AP

## Шаг 2 — Прошивка LineageOS GSI

Скачай образ LineageOS 22.2 GSI для ARM64 + AB:
```
wget https://sourceforge.net/projects/lineageos-gsi/files/22/lineage-22.2-XXXXXX-arm64_bvN.img
```

Прошей:
```
fastboot flash system lineage-22.2-XXXXXX-arm64_bvN.img
fastboot -w
fastboot reboot
```

## Шаг 3 — Установка Magisk

1. Скачай Magisk APK: https://github.com/topjohnwu/Magisk/releases
2. Сделай `adb install Magisk-*.apk`
3. Открой Magisk → «Install» → «Direct Install» (если уже есть root)
   или «Patch Boot Image» если нет

## Шаг 4 — Установка RuslanOS модуля

1. Скачай `ruslanos-setup.zip` из [Releases](https://github.com/valldun1/RuslanOS/releases)
2. Открой Magisk → «Модули» → «Установить из ZIP»
3. Выбери `ruslanos-setup.zip`
4. Перезагрузи устройство

## Шаг 5 — Установка RuslanShell

1. Скачай `RuslanShell.apk` из [Releases](https://github.com/valldun1/RuslanOS/releases)
2. `adb install RuslanShell.apk`
3. В настройках → «Приложения по умолчанию» → «Домашнее приложение» → выбери RuslanShell

## Готово!

Теперь при загрузке телефона ты увидишь экран **RuslanOS**.
