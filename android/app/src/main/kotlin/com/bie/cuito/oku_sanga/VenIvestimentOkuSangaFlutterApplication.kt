package com.bie.cuito.oku_sanga
import io.flutter.app.FlutterApplication
import io.flutter.plugins.androidalarmmanager.AlarmService
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin


class VenIvestimentOkuSangaFlutterApplication : FlutterApplication(), io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        // AlarmService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: io.flutter.plugin.common.PluginRegistry) {
        AndroidAlarmManagerPlugin.registerWith(
                registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"))
    }
}