package com.ruslanos.shell.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val DarkColorScheme = darkColorScheme(
    primary = Color(0xFF4444AA),
    onPrimary = Color(0xFFE8E8E8),
    secondary = Color(0xFF6666CC),
    background = Color(0xFF0D0D1A),
    surface = Color(0xFF1A1A2E),
    onBackground = Color(0xFFE8E8E8),
    onSurface = Color(0xFFE8E8E8),
    outline = Color(0xFF333355)
)

@Composable
fun RuslanOSTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = DarkColorScheme,
        content = content
    )
}
