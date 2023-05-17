import 'package:get/get.dart';

import '../../data/data_sources/local/local_storage.dart';
import '../../data/data_sources/remote/repositories/account_repository.dart';
import '../../data/data_sources/remote/repositories/transaction_repo.dart';
import '../../domain/repositories/account_repository_impl.dart';
import '../../domain/repositories/transactions_repository_impl.dart';
import '../ui/pay/pay_controller.dart';


class PayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountRepository>(
          () => AccountRepositoryImpl(

        Get.find<LocalStorage>(),
      ),
      fenix: true,
    );
    Get.lazyPut<TransactionRepository>(
          () => TransactionsRepositoryImpl(
        Get.find<LocalStorage>(),
      ),
      fenix: true,
    );
    Get.put(
      PayController(
        Get.find<AccountRepository>(),
        Get.find<TransactionRepository>(),
      ),
    );
  }
}