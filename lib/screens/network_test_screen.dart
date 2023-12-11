import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/models/ip_details.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import 'package:vpn_basic_project/widgets/network_card.dart';

import '../apis/apis.dart';
import '../main.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о сети'),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.refresh),
          onPressed: () {
            ipData.value = IPDetails.fromJson({});
            APIs.getIPDetails(ipData: ipData);
          }
        ),
      ),
      body: Obx(()=>ListView(
        padding: EdgeInsets.only(
          left: mq.width * .04,
          right: mq.width * .04,
          top: mq.height * .015,
          bottom: mq.height * .01,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          //ip
          NetworkCard(
            data: NetworkData(
              title: 'IP-адрес',
              subtitle: ipData.value.query,
              icon: Icon(
                CupertinoIcons.location_solid,
                color: Colors.blue,
              ),
            ),
          ),
          //isp
          NetworkCard(
            data: NetworkData(
              title: 'Интернет провайдер',
              subtitle: ipData.value.isp,
              icon: Icon(
                Icons.business,
                color: Colors.orange,
              ),
            ),
          ),
          //location
          NetworkCard(
            data: NetworkData(
              title: 'Местоположение',
              subtitle: ipData.value.country.isEmpty
                  ? 'Загрузка ...'
                  : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
              icon: Icon(
                CupertinoIcons.location,
                color: Colors.pink,
              ),
            ),
          ),
          //pin code
          NetworkCard(
            data: NetworkData(
              title: 'Пин код',
              subtitle: ipData.value.zip.isNotEmpty?ipData.value.zip:'-',
              icon: Icon(
                CupertinoIcons.location_solid,
                color: Colors.cyan,
              ),
            ),
          ),
          //timezone
          NetworkCard(
            data: NetworkData(
              title: 'Часовой пояс',
              subtitle: ipData.value.timezone,
              icon: Icon(
                CupertinoIcons.time,
                color: Colors.green,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
