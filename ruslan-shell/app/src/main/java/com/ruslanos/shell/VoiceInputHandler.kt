package com.ruslanos.shell

/**
 * Обработчик голосового ввода для RuslanOS.
 * Использует SpeechRecognizer или WebView с whisper API.
 */
class VoiceInputHandler {
    // TODO: Реализовать интеграцию с системным SpeechRecognizer
    // или WebView с whisper.cpp / OpenAI Whisper API

    fun isAvailable(): Boolean = false

    fun startListening(): String {
        return "Голосовой ввод пока в разработке. Скоро можно будет просто говорить!"
    }
}
