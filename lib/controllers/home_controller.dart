import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vpn_basic_project/helpers/my_dialogs.dart';

import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<Vpn> vpn = Pref.vpn.obs;

  final RxString vpnState = VpnEngine.vpnDisconnected.obs;

  void connectToVpn() {
    if (vpn.value.openVPNConfigDataBase64.isEmpty) {
      MyDialogs.info(
        msg: 'Select a Location by clicking \'Change Location\'',);
      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final data = Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);
      final config = Utf8Decoder().convert(data);

      final vpnConfig = VpnConfig(
          country: vpn.value.countryLong,
          username: 'vpn',
          password: 'vpn',
          config: config);

      VpnEngine.startVpn(vpnConfig);
    } else {
      ///Stop if stage is "not" disconnected
      VpnEngine.stopVpn();
    }
  }

  Future<void> initializeData() async {}

  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;
      case VpnEngine.vpnConnected:
        return Colors.green;
      default:
        return Colors.orangeAccent;
    }
  }

  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';

      case VpnEngine.vpnConnected:
        return 'Disconnect';

      default:
        return 'Connecting...';
    }
  }
}
