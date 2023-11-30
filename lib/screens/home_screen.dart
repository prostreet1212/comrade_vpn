import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';

import '../main.dart';
import '../models/vpn_config.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('Comrade VPN'),
        actions: [
          IconButton(
              onPressed: () {
                Get.changeThemeMode(Get.isDarkMode?ThemeMode.light:ThemeMode.dark);
              },
              icon: Icon(
                Icons.brightness_medium,
                size: 26,
              )),
          IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.info,
                size: 27,
              ))
        ],
      ),
      bottomNavigationBar: _changeLocation(),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Obx(
          () => _vpnButton(),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                title: _controller.vpn.value.countryLong.isEmpty
                    ? 'Country'
                    : _controller.vpn.value.countryLong,
                subtitle: 'FREE',
                icon: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                  child: _controller.vpn.value.countryLong.isEmpty
                      ? Icon(
                          Icons.vpn_lock_rounded,
                          size: 30,
                        )
                      : null,
                  backgroundImage: _controller.vpn.value.countryLong.isEmpty
                      ? null
                      : AssetImage(
                          'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
                ),
              ),
              HomeCard(
                title: _controller.vpn.value.countryLong.isEmpty
                    ? '100 ms'
                    : '${_controller.vpn.value.ping} ms',
                subtitle: 'PING',
                icon: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.equalizer_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<VpnStatus?>(
          initialData: VpnStatus(),
          stream: VpnEngine.vpnStatusSnapshot(),
          builder: (context, snapshot) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                title: '${snapshot.data?.byteIn ?? '0 kbps'}',
                subtitle: 'Download',
                icon: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.lightGreen,
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              HomeCard(
                title: '${snapshot.data?.byteOut ?? '0 kbps'}',
                subtitle: 'Upload',
                icon: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }



  Widget _vpnButton() => Column(children: [
        Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              _controller.connectToVpn();
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _controller.getButtonColor.withOpacity(.1),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _controller.getButtonColor.withOpacity(.3),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: mq.height * .14,
                  height: mq.height * .14,
                  decoration: BoxDecoration(
                    color: _controller.getButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.power_settings_new,
                        size: 28,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        _controller.getButtonText,
                        style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin:
              EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          child: Text(
            _controller.vpnState.value == VpnEngine.vpnDisconnected
                ? 'Not Connected'
                : _controller.vpnState.replaceAll('_', '').toUpperCase(),
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.white,
            ),
          ),
        ),
        Obx(() => CountDownTimer(
            startTimer: _controller.vpnState.value == VpnEngine.vpnConnected)),
      ]);

  Widget _changeLocation() => SafeArea(
        child: Semantics(
          button: true,
          child: InkWell(
            onTap: () => Get.to(() => LocationScreen()),
            child: Container(
              color: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              height: 60,
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.globe,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Change Location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.blue,
                      size: 28,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
