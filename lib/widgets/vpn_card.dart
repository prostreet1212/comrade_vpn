import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';

import '../controllers/home_controller.dart';
import '../helpers/my_dialogs.dart';
import '../helpers/pref.dart';
import '../main.dart';

class VpnCard extends StatelessWidget {
  final Vpn vpn;

  const VpnCard({Key? key, required this.vpn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller=Get.find<HomeController>();
    return Card(
      margin:EdgeInsets.symmetric(vertical: mq.height*.01) ,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: (){
          controller.vpn.value=vpn;
          Pref.vpn=vpn;
          Get.back();
          MyDialogs.success(msg: 'Поключение к серверу');
          if(controller.vpnState.value==VpnEngine.vpnConnected){
            VpnEngine.stopVpn();
            Future.delayed(Duration(seconds: 2),()=> controller.connectToVpn()
            );

          }else{
            controller.connectToVpn();

          }

        },
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(.5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                'assets/flags/${vpn.countryShort.toLowerCase()}.png',
                height: 40,
                width: mq.width*.15,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(vpn.countryLong),
          subtitle: Row(
            children: [
              Icon(
                Icons.speed_rounded,
                color: Colors.blue,
                size: 20,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                _formatBytes(vpn.speed, 1),
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vpn.numVpnSessions.toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).lightText,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Icon(
                CupertinoIcons.person_3,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ['Bps', "Kbps", "Mbps", "Gbps", "Tbps"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

}
