import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import 'package:vpn_basic_project/widgets/network_card.dart';

import '../main.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Test Screen'),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          child: Icon(CupertinoIcons.refresh),
          onPressed: () {},
        ),
      ),
      body: ListView(
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
              title: 'IP Address',
              subtitle: 'Not available',
              icon: Icon(
                CupertinoIcons.location_solid,
                color: Colors.blue,
              ),
            ),
          ),
          //isp
          NetworkCard(
            data: NetworkData(
              title: 'Internet Provider',
              subtitle: 'Unknown',
              icon: Icon(
                Icons.business,
                color: Colors.orange,
              ),
            ),
          ),
          //location
          NetworkCard(
            data: NetworkData(
              title: 'Location',
              subtitle: 'Fetching ...',
              icon: Icon(
                CupertinoIcons.location,
                color: Colors.pink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
