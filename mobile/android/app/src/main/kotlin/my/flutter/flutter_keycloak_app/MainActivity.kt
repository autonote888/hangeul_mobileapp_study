package my.flutter.flutter_keycloak_app

import android.os.Bundle
import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity(), TextToSpeech.OnInitListener {
    private val channelName = "saturnus.app/korean_tts"
    private var tts: TextToSpeech? = null
    private var isTtsReady = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        tts = TextToSpeech(this, this)
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            val result = tts?.setLanguage(Locale.KOREAN)
            isTtsReady = result != TextToSpeech.LANG_MISSING_DATA &&
                    result != TextToSpeech.LANG_NOT_SUPPORTED
            if (!isTtsReady) {
                tts?.setLanguage(Locale.getDefault())
                isTtsReady = true
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "speakKorean" -> {
                        val text = call.argument<String>("text") ?: ""
                        val rate = call.argument<Double>("rate")?.toFloat() ?: 0.85f
                        val pitch = call.argument<Double>("pitch")?.toFloat() ?: 1.0f

                        if (isTtsReady && text.isNotEmpty()) {
                            tts?.setLanguage(Locale.KOREAN)
                            tts?.setSpeechRate(rate)
                            tts?.setPitch(pitch)
                            tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null, "hangeul_utt")
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    }
                    "stop" -> {
                        tts?.stop()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        tts?.stop()
        tts?.shutdown()
        super.onDestroy()
    }
}
