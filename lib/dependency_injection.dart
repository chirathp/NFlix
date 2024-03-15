import 'package:nflix/connectivity/network.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DependencyInjection {

  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}