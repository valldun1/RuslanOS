# RuslanOS — Makefile
# Быстрые команды для разработки

.PHONY: help gsi rom flash module test env

help:          ## Показать помощь
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

env:           ## Настроить билд-среду (OrbStack/Linux)
	bash scripts/setup-build-env.sh

gsi:           ## Собрать RuslanOS GSI прототип
	bash scripts/build-gsi.sh

rom:           ## Собрать полный ROM
	bash scripts/build-full-rom.sh

module:        ## Собрать Magisk-модуль
	@echo "Сборка ruslanos-setup.zip..."
	cd ruslanos-module && \
	zip -r ../out/ruslanos-setup-v0.1.0.zip . && \
	echo "✅ Готово: out/ruslanos-setup-v0.1.0.zip"

flash:         ## Прошить GSI на устройство (fastboot)
	@echo "Убедись, что устройство в fastboot!"
	@echo "Использование: make flash IMG=path/to/system.img"
	fastboot flash system $(IMG)
	fastboot -w
	fastboot reboot

test:          ## Запустить проверку устройства
	bash scripts/device-check.sh

clean:         ## Очистить артефакты сборки
	rm -rf out/
	rm -rf build/
