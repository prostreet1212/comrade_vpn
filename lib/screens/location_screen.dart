import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:vpn_basic_project/widgets/vpn_card.dart';

import '../main.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _controller = LocationController(); //Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    _controller.getVPNData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('VPN Locations (${_controller.vpnList.length})'),
        ),
        body: _controller.isLoading.value
            ? _loadingWidget()
            : _controller.vpnList.isEmpty
                ? _noVPNFound()
                : _vpnData(),
      ),
    );
  }

  _vpnData() => ListView.builder(
    physics: BouncingScrollPhysics(),
      itemCount: _controller.vpnList.length,
      padding: EdgeInsets.only(top: mq.height * .015,
          bottom: mq.height * .1,
      left: mq.width*.04,right: mq.width*.04,),
      itemBuilder: (context, i) {
        return VpnCard(
          vpn: _controller.vpnList[i],
        );
      });

  _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/lottie/loading.json',
              width: mq.width * .7,
            ),
            Text(
              'loading VPNs...😌',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  _noVPNFound() => Center(
        child: Text(
          'VPNs not found 😔',
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      );
}
