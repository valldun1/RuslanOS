package com.ruslanos.shell

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.ruslanos.shell.ui.RuslanOSApp
import com.ruslanos.shell.ui.theme.RuslanOSTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            RuslanOSTheme {
                Surface(modifier = Modifier.fillMaxSize()) {
                    RuslanOSApp()
                }
            }
        }
    }
}
