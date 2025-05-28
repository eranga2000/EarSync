package com.example.music_player

import android.content.Intent
import android.os.Bundle 
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.music_player/share"
    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        // Handle intent if the app was started by a share action or if it's already running
        handleSendIntent(intent)
    }

    // onCreate is called before configureFlutterEngine.
    // We handle the intent in configureFlutterEngine to ensure the channel is ready.
    // If the app is launched from a terminated state by a share intent, getIntent() in
    // configureFlutterEngine will have the intent.
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // No need to call handleSendIntent here as it's called in configureFlutterEngine
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Handle intent if the app is already running and receives a new share action
        // At this point, methodChannel should be initialized.
        handleSendIntent(intent)
    }

    private fun handleSendIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_SEND && intent.type == "text/plain") {
            intent.getStringExtra(Intent.EXTRA_TEXT)?.let { sharedText ->
                if (::methodChannel.isInitialized) {
                    methodChannel.invokeMethod("handleSharedLink", sharedText)
                } else {
                    // This case should ideally not happen if called from configureFlutterEngine or onNewIntent
                    // after configureFlutterEngine has run.
                    println("MethodChannel not initialized when trying to send link from handleSendIntent.")
                }
            }
        }
    }
}
