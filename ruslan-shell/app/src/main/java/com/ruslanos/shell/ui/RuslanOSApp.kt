package com.ruslanos.shell.ui

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay

@Composable
fun RuslanOSApp() {
    var currentScreen by remember { mutableStateOf("splash") }

    LaunchedEffect(currentScreen) {
        if (currentScreen == "splash") {
            delay(3000)
            currentScreen = "chat"
        }
    }

    when (currentScreen) {
        "splash" -> SplashScreen()
        "chat" -> ChatScreen()
    }
}

@Composable
fun SplashScreen() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF0D0D1A)),
        contentAlignment = Alignment.Center
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Text(
                text = "🛡",
                fontSize = 72.sp
            )
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = "RuslanOS",
                fontSize = 36.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFFE8E8E8)
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "говори — и система сделает",
                fontSize = 14.sp,
                color = Color(0xFF8888AA),
                textAlign = TextAlign.Center
            )
        }
    }
}

@Composable
fun ChatScreen() {
    var messages by remember { mutableStateOf(listOf<ChatMessage>()) }
    var inputText by remember { mutableStateOf("") }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF0D0D1A))
    ) {
        Column(modifier = Modifier.fillMaxSize()) {
            // Header
            Surface(
                modifier = Modifier.fillMaxWidth(),
                color = Color(0xFF1A1A2E),
                shadowElevation = 4.dp
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 12.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("🛡", fontSize = 20.sp)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "RuslanOS",
                        fontSize = 18.sp,
                        fontWeight = FontWeight.SemiBold,
                        color = Color(0xFFE8E8E8)
                    )
                }
            }

            // Messages
            LazyColumn(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp),
                verticalArrangement = Arrangement.Bottom
            ) {
                items(messages.size) { index ->
                    val msg = messages[index]
                    MessageBubble(msg)
                    Spacer(modifier = Modifier.height(8.dp))
                }

                // Welcome message
                if (messages.isEmpty()) {
                    item {
                        WelcomeBlock()
                    }
                }
            }

            // Input bar
            Surface(
                modifier = Modifier.fillMaxWidth(),
                color = Color(0xFF1A1A2E),
                shadowElevation = 8.dp
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 12.dp, vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    OutlinedTextField(
                        value = inputText,
                        onValueChange = { inputText = it },
                        modifier = Modifier.weight(1f),
                        placeholder = {
                            Text(
                                "Напиши Руслану...",
                                color = Color(0xFF666680)
                            )
                        },
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedTextColor = Color(0xFFE8E8E8),
                            unfocusedTextColor = Color(0xFFE8E8E8),
                            focusedBorderColor = Color(0xFF4444AA),
                            unfocusedBorderColor = Color(0xFF333355),
                            cursorColor = Color(0xFF6666CC)
                        ),
                        shape = RoundedCornerShape(12.dp),
                        singleLine = true,
                        maxLines = 1
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Button(
                        onClick = {
                            if (inputText.isNotBlank()) {
                                messages = messages + ChatMessage(inputText, isUser = true)
                                inputText = ""
                            }
                        },
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xFF4444AA)
                        ),
                        shape = RoundedCornerShape(12.dp)
                    ) {
                        Text("→", fontSize = 18.sp)
                    }
                }
            }
        }
    }
}

@Composable
fun WelcomeBlock() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = Color(0xFF1A1A2E)),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(modifier = Modifier.padding(20.dp)) {
            Text(
                text = "🛡 Руслан на связи",
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFFE8E8E8)
            )
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                text = "Я — твоя операционная система. Могу:\n\n" +
                        "📦 Установить приложение\n" +
                        "⚙️ Настроить систему\n" +
                        "🔍 Найти информацию\n" +
                        "💬 Просто поболтать\n\n" +
                        "Что нужно сделать?",
                fontSize = 14.sp,
                color = Color(0xFF9999BB),
                lineHeight = 22.sp
            )
        }
    }
}

@Composable
fun MessageBubble(message: ChatMessage) {
    val alignment = if (message.isUser) Alignment.End else Alignment.Start
    val color = if (message.isUser) Color(0xFF4444AA) else Color(0xFF1A1A2E)
    val textColor = if (message.isUser) Color(0xFFE8E8E8) else Color(0xFFBBBBCC)

    AnimatedVisibility(
        visible = true,
        enter = fadeIn()
    ) {
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = if (message.isUser) Alignment.End else Alignment.Start
        ) {
            Card(
                colors = CardDefaults.cardColors(containerColor = color),
                shape = RoundedCornerShape(
                    topStart = 16.dp,
                    topEnd = 16.dp,
                    bottomStart = if (message.isUser) 16.dp else 4.dp,
                    bottomEnd = if (message.isUser) 4.dp else 16.dp
                )
            ) {
                Text(
                    text = message.text,
                    modifier = Modifier.padding(horizontal = 14.dp, vertical = 10.dp),
                    color = textColor,
                    fontSize = 14.sp,
                    maxLines = 20,
                    overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}

data class ChatMessage(
    val text: String,
    val isUser: Boolean
)
