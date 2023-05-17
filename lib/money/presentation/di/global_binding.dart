import 'package:get/get.dart';

import '../../data/data_sources/local/local_storage.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocalStorage>(
          () => LocalStorage(),
      fenix: true,
    );
  }
}