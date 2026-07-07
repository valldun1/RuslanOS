# Тестирование RuslanOS

## Прежде чем начать

1. У тебя есть **второй телефон** — не основной! Прошивка экспериментальная.
2. Разблокирован bootloader.
3. Установлены `adb` и `fastboot`.

## Тест 1: Проверка совместимости

```bash
# Подключи телефон через USB (Android Debugging включён)
adb devices
adb shell getprop ro.build.version.sdk    # должно быть >= 30
adb shell getprop ro.product.cpu.abi      # arm64-v8a
adb shell getprop ro.boot.verifiedbootstate  # orange = разблокирован
```

## Тест 2: GSI прошивка

```bash
# Скачай LineageOS GSI
# Переведи в fastboot
adb reboot bootloader

# Прошей
fastboot flash system <gsi-image>.img
fastboot -w
fastboot reboot
```

**Ожидание:** телефон загружается в чистый LineageOS.
**Проверка:** работает ли сенсор, WiFi, звук?

## Тест 3: Magisk + RuslanOS модуль

```bash
# Установи Magisk
adb install Magisk-*.apk

# Закинь модуль
adb push ruslanos-setup-v0.1.0.zip /sdcard/

# На телефоне: Magisk → Модули → Установить из ZIP
# Перезагрузка
```

**Ожидание:** после загрузки запускается RuslanShell (тёмный экран с чатом).
**Проверка:**
- Открывается ли чат?
- Работает ли отправка сообщений?
- Есть ли команда `ruslan` в терминале (через ADB)?

## Тест 4: Lock Task Mode (киоск)

```bash
# Через ADB:
adb shell dpm set-device-owner com.ruslanos.shell/.DeviceAdminReceiver
```

**Ожидание:** из RuslanShell нельзя выйти (нет кнопки Home/Recents).
**Выход:** `adb shell dpm remove-active-admin com.ruslanos.shell/.DeviceAdminReceiver`

## Тест 5: CommandProcessor

Через ADB отправь команды:
```bash
adb shell am broadcast -a com.ruslanos.COMMAND --es command "статус"
adb shell am broadcast -a com.ruslanos.COMMAND --es command "помоги"
```

**Ожидание:** в логах видно, что команды обработаны.

## Тест 6: Долгая работа

- Оставь телефон на ночь с RuslanOS.
- Утром проверь: не вылетел ли Руслан, не перегрелся ли, какой расход батареи.
- `adb shell dumpsys batterystats` — статистика.

## Чек-лист перед релизом

- [ ] GSI прошивается и загружается
- [ ] Magisk модуль устанавливается без ошибок
- [ ] RuslanShell запускается как лаунчер
- [ ] Lock Task Mode работает
- [ ] Команды выполняются
- [ ] Батарея держится не хуже стока
- [ ] WiFi работает
- [ ] Мобильная сеть работает
- [ ] Экран блокировки не мешает
- [ ] Перезагрузка: агент запускается автоматически
