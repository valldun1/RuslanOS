# Поддержка устройств RuslanOS

RuslanOS базируется на LineageOS 22.2 (Android 15). Для установки нужно устройство с **Project Treble** и **разблокированным bootloader**.

## Проверка совместимости

Запусти на устройстве (через ADB или терминал):

```bash
adb shell sh scripts/device-check.sh
```

Или проверь вручную:

1. **Project Treble**: Android 8.0+ (API 26+)  
   Проверка: `getprop ro.build.version.sdk` → должно быть ≥ 26

2. **A/B слоты**:  
   `getprop ro.boot.slot_suffix` → если не пусто — A/B, иначе A-only

3. **Bootloader разблокирован**:  
   `fastboot oem device-info` или смотреть `ro.boot.verifiedbootstate=orange`

4. **Архитектура**:  
   `getprop ro.product.cpu.abi` → должно быть `arm64-v8a`

## Рекомендованные устройства

### Xiaomi (основная цель)
| Модель | Кодовое имя | Treble | A/B | Статус |
|--------|-------------|--------|-----|--------|
| Xiaomi 14 | shennong | ✅ | A/B | 🟢 тестируется |
| Xiaomi 14T | peridot | ✅ | A/B | 🟢 |
| Xiaomi 14T Pro | peridot | ✅ | A/B | 🟢 |
| Xiaomi 14 Ultra | aurora | ✅ | A/B | 🟢 |
| Xiaomi 13 | fuxi | ✅ | A/B | 🟢 |
| Xiaomi 13T | aristotle | ✅ | A/B | 🟢 |
| Redmi Note 13 | ruby | ✅ | A-only | 🟡 |

### Google Pixel
| Модель | Treble | A/B | Замечание |
|--------|--------|-----|-----------|
| Pixel 6+ | ✅ | A/B | 🟢 лучшая поддерка GrapheneOS |
| Pixel 7+ | ✅ | A/B | 🟢 |
| Pixel 8+ | ✅ | A/B | 🟢 |
| Pixel 9 | ✅ | A/B | 🟢 |

### OnePlus
| Модель | Treble | A/B | Замечание |
|--------|--------|-----|-----------|
| OnePlus 12 | ✅ | A/B | 🟢 |
| OnePlus Open | ✅ | A/B | 🟢 |

### Fairphone
| Модель | Treble | A/B | Замечание |
|--------|--------|-----|-----------|
| Fairphone 5 | ✅ | A | 🟡 |

## Легенда
- 🟢 — полная поддержка, проверено
- 🟡 — поддержка есть, требует тестирования
- 🔴 — не поддерживается
- ⚪ — не тестировалось

## Добавить своё устройство

Если твоего устройства нет в списке:

1. Установи `Treble Check` из Play Store / Aurora Store
2. Сделай скриншот и открой Issue на GitHub
3. Или напиши Руслану: *«Проверь совместимость»*
