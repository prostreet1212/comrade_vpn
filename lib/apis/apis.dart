import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart';
import 'package:vpn_basic_project/helpers/my_dialogs.dart';

import '../helpers/pref.dart';
import '../models/ip_details.dart';
import '../models/vpn.dart';

class APIs {
  static Future<List<Vpn>> getVPNServers() async {
    final List<Vpn> vpnList = [];

    try {
      final res =
          await get(Uri.parse('https://download.vpngate.jp/api/iphone/'));
      //final res = await get(Uri.parse('https://www.vpngate.net/api/iphone/'));
      //String res=await rootBundle.loadString('assets/vpn/server_list.csv');
      final csvString = res.body.split("#")[1].replaceAll('*', '');

      List<List<dynamic>> list = CsvToListConverter().convert(csvString);
      final header = list[0];
      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};
        if (list[i].isNotEmpty) {
          for (int j = 0; j < header.length; ++j) {
            tempJson.addAll({header[j].toString(): list[i][j]});
          }
          vpnList.add(Vpn.fromJson(tempJson));
        }
      }
      print(vpnList.first.hostname);
    } catch (e) {
      MyDialogs.error(msg: e.toString());
      print('getVPNServerE: $e');
    }
    vpnList.shuffle();
    if (vpnList.isNotEmpty) Pref.vpnList = vpnList;

    return vpnList;
  }

  static Future<void> getIPDetails({required Rx<IPDetails> ipData}) async {
    try {
      final Response res = await get(Uri.parse('http://ip-api.com/json/'));
      final data = jsonDecode(res.body);
      ipData.value = IPDetails.fromJson(data);
    } on Exception catch (e) {
      MyDialogs.error(msg: e.toString());
      print('getIPDetailsE: $e');
    }
  }
}
