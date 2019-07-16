package ko2ic.spikeflutter

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel


class MainActivity() : FlutterActivity() {

    companion object {
        const val CHANNEL = "sample.ko2ic/toPlatformScreen"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "toPlatformScreen" -> {
                    val label = call.argument<String>("label_from_dart")
                    startActivity(NextActivity.intent(this@MainActivity).apply {
                        putExtra("label", label)
                    })
                    result.success("success!!")
                }
                else -> result.notImplemented()
            }
        }
    }
}
