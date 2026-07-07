package com.ruslanos.shell

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.BufferedReader
import java.io.InputStreamReader

/**
 * Обработчик команд Руслана в ОС.
 * Выполняет системные команды от имени пользователя.
 */
class CommandProcessor {

    suspend fun process(command: String): String = withContext(Dispatchers.IO) {
        when {
            command.startsWith("установи ") || command.startsWith("install ") -> {
                val app = command.removePrefix("установи ").removePrefix("install ").trim()
                installApp(app)
            }
            command.startsWith("запусти ") || command.startsWith("run ") -> {
                val app = command.removePrefix("запусти ").removePrefix("run ").trim()
                runApp(app)
            }
            command.startsWith("смени обои") || command.startsWith("wallpaper") -> {
                setWallpaper()
            }
            command.startsWith("статус") || command.startsWith("status") -> {
                systemStatus()
            }
            command.startsWith("помоги") || command.startsWith("help") || command.startsWith("команды") -> {
                helpText()
            }
            else -> {
                // Пробуем выполнить как shell-команду
                execShell(command)
            }
        }
    }

    private fun installApp(packageName: String): String {
        return runShell("pm install --user 0 $packageName 2>&1 || echo 'FAILED'")
    }

    private fun runApp(packageName: String): String {
        return runShell("monkey -p $packageName 1 2>&1 || echo 'FAILED'")
    }

    private fun setWallpaper(): String {
        return "Команда смены обоев — пока в разработке. " +
                "Скоро Руслан сможет менять оформление системы по твоему желанию."
    }

    private fun systemStatus(): String {
        val battery = runShell("dumpsys battery | grep level | awk '{print \$2}'").trim()
        val storage = runShell("df -h /data | tail -1 | awk '{print \$3 \"/\" \$2}'").trim()
        val uptime = runShell("uptime -p 2>/dev/null || echo 'N/A'").trim()
        val wifi = runShell("dumpsys wifi | grep 'Wi-Fi is' || echo 'N/A'").trim()
        return """
            |📊 **Статус системы**
            |🔋 Батарея: $battery%
            |💾 Память: $storage
            |⏱ Аптайм: $uptime
            |📡 WiFi: $wifi
        """.trimMargin()
    }

    private fun helpText(): String {
        return """
            |🛡 **Команды Руслана:**
            |• `установи <пакет>` — установить приложение
            |• `запусти <пакет>` — запустить приложение
            |• `смени обои` — сменить обои (скоро)
            |• `статус` — информация о системе
            |• `помоги` — этот список
            |
            |Также можно просто написать shell-команду.
        """.trimMargin()
    }

    private fun execShell(cmd: String): String {
        val output = runShell(cmd)
        return if (output.isBlank()) "✅ Команда выполнена (нет вывода)" else "```\n$output\n```"
    }

    private fun runShell(command: String): String {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("sh", "-c", command))
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val errorReader = BufferedReader(InputStreamReader(process.errorStream))
            val output = reader.readText()
            val error = errorReader.readText()
            process.waitFor()
            if (error.isNotBlank()) output + "\n⚠️ Ошибки:\n$error" else output
        } catch (e: Exception) {
            "❌ Ошибка: ${e.message}"
        }
    }
}
