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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HomeController();
  List<VpnConfig> _listVpn = [];
  VpnConfig? _selectedVpn;

  @override
  void initState() {
    super.initState();

    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    initVpn();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initVpn() async {
    //sample vpn config file (you can get more from https://www.vpngate.net/)
    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/japan.ovpn'),
        country: 'Japan',
        username: 'vpn',
        password: 'vpn'));

    _listVpn.add(VpnConfig(
        config: await rootBundle.loadString('assets/vpn/thailand.ovpn'),
        country: 'Thailand',
        username: 'vpn',
        password: 'vpn'));

    SchedulerBinding.instance.addPostFrameCallback(
        (t) => setState(() => _selectedVpn = _listVpn.first));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('Comrade VPN'),
        actions: [
          IconButton(
              onPressed: () {},
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeCard(
              title: 'Country',
              subtitle: 'FREE',
              icon: CircleAvatar(
                radius: 30,
                child: Icon(
                  Icons.vpn_lock_rounded,
                  size: 30,
                ),
              ),
            ),
            HomeCard(
              title: '100 ms',
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
        StreamBuilder<VpnStatus?>(
          initialData: VpnStatus(),
          stream: VpnEngine.vpnStatusSnapshot(),
          builder: (context, snapshot) =>
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeCard(
                    title: '${snapshot.data?.byteIn??'0 kbps'}',
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
                    title: '${snapshot.data?.byteOut??'0 kbps'}',
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



        /*  Center(
            child: TextButton(
              style: TextButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                _vpnState == VpnEngine.vpnDisconnected
                    ? 'Connect VPN'
                    : _vpnState.replaceAll("_", " ").toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _connectClick,
            ),
          ),
          StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.vpnStatusSnapshot(),
            builder: (context, snapshot) => Text(
                "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
                textAlign: TextAlign.center),
          ),

          //sample vpn list
          Column(
              children: _listVpn
                  .map(
                    (e) => ListTile(
                  title: Text(e.country),
                  leading: SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: _selectedVpn == e
                            ? CircleAvatar(
                            backgroundColor: Colors.green)
                            : CircleAvatar(
                            backgroundColor: Colors.grey)),
                  ),
                  onTap: () {
                    log("${e.country} is selected");
                    setState(() => _selectedVpn = e);
                  },
                ),
              )
                  .toList())*/
      ]),
    );
  }

  void _connectClick() {
    ///Stop right here if user not select a vpn
    if (_selectedVpn == null) return;

    if (_controller.vpnState.value == VpnEngine.vpnDisconnected) {
      ///Start if stage is disconnected
      _controller.startTimer.value=true;
      VpnEngine.startVpn(_selectedVpn!);
    } else {
      ///Stop if stage is "not" disconnected
      _controller.startTimer.value=false;
      VpnEngine.stopVpn();
    }
  }

  Widget _vpnButton() => Column(children: [
        Semantics(
          button: true,
          child: InkWell(
            onTap: () {
              _connectClick();
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
