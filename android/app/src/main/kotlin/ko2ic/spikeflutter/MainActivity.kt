package ko2ic.spikeflutter

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel


class MainActivity() : FlutterActivity() {

    companion object {
        const val CHANNEL = "sample.ko2ic/toPlatformScreen"
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler(
            object : MethodCallHandler {
                override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                    if (call.method.equals("toPlatformScreen")) {
                        startActivity(NextActivity.intent(this@MainActivity))
                    } else {
                        result.notImplemented()
                    }
                }
            })
    }
}
