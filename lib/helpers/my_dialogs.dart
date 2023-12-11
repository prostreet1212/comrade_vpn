import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MyDialogs {
  static success({required String msg}) {
    Get.snackbar(
      'Сообщение',
      msg,
      colorText: Colors.white,
      backgroundColor: Colors.green.withOpacity(.9),
    );
  }

  static error({required String msg}) {
    Get.snackbar(
      'Ошибка',
      msg,
      colorText: Colors.white,
      backgroundColor: Colors.redAccent.withOpacity(.9),
    );
  }

  static info({required String msg}) {
    Get.snackbar('Инфо', msg, colorText: Colors.white);
  }
}
