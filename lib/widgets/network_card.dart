import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import '../controllers/home_controller.dart';
import '../main.dart';

class NetworkCard extends StatelessWidget {
  final NetworkData data;

  const NetworkCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Card(
      margin: EdgeInsets.symmetric(vertical: mq.height * .01),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          leading: Icon(
            data.icon.icon,
            color: data.icon.color,
            size: data.icon.size ?? 28,
          ),
          title: Text(data.title),
          subtitle: Text(data.subtitle),
        ),
      ),
    );
  }
}
