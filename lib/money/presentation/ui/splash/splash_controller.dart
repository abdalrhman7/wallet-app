import 'package:get/get.dart';
import 'package:money_app/shared/utils/utils.dart';

import '../../router/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    start();
  }

  void start() async {
    await delayedFunc(milliseconds: 1500);
    goTransactions();
  }

  void goTransactions() => Get.offAllNamed(AppRoutes.transactions);
}