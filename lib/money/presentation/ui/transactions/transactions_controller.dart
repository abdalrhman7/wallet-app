import 'package:get/get.dart';
import 'package:money_app/money/data/data_sources/remote/repositories/transaction_repo.dart';

import 'package:money_app/shared/enums/screen_enums.dart';
import 'package:money_app/shared/enums/transaction_enums.dart';

import '../../../data/data_sources/local/local_storage.dart';
import '../../../data/data_sources/remote/repositories/account_repository.dart';
import '../../../domain/entities/account_model.dart';
import '../../../domain/entities/transaction_model.dart';
import '../../router/routes.dart';

class TransactionsController extends GetxController {
  ScreenEnums _screenEnum = ScreenEnums.loaded;
  ScreenEnums get screenEnum => _screenEnum;
  set screenEnum(ScreenEnums v) {
    _screenEnum = v;
    update();
  }

  final LocalStorage _storage;
  final AccountRepository _accountRepository;
  final TransactionRepository _transactionsRepository;

  TransactionsController(
      this._storage,
      this._accountRepository,
      this._transactionsRepository,
      );


  AccountModel? account;
  List<TransactionModel?> transactions = <TransactionModel>[];

  @override
  void onInit() async {
    super.onInit();
    screenEnum = ScreenEnums.loading;
    await Future.wait([
      getAccountData(),
      getTransactions(),
    ]);
    screenEnum = ScreenEnums.loaded;
    if (account == null) {
      screenEnum = ScreenEnums.error;
    }
  }

  Future<void> getAccountData() async {
    account = await _accountRepository.getAccount();
  }

  Future<void> getTransactions() async {
    transactions = await _transactionsRepository.getTransactions();
  }

  void onTapPay() => goPay(TransactionsEnums.pay);

  void onTapTopUp() => goPay(TransactionsEnums.topUp);

  void goPay(final TransactionsEnums type) async {
    final res = await Get.toNamed(
      AppRoutes.pay,
      arguments: type,
    );
    if (res == ScreenEnums.refresh) {
      onInit();
    }
  }

  void goTransaction(final String? id) async {
    if (id != null) {
      final res = await Get.toNamed(
        AppRoutes.transactionDetails,
        arguments: id,
      );
      if (res == ScreenEnums.refresh) {
        onInit();
      }
    }
  }

  void dropData() async {
    await _storage.clearBox();
    onInit();
  }
}