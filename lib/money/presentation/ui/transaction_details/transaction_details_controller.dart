import 'package:get/get.dart';
import 'package:money_app/shared/constants/app_values.dart';
import 'package:money_app/shared/core/localization/keys.dart';
import 'package:money_app/shared/enums/screen_enums.dart';
import 'package:money_app/shared/utils/date_utils.dart';
import 'package:money_app/shared/utils/utils.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../data/data_sources/remote/repositories/account_repository.dart';
import '../../../data/data_sources/remote/repositories/transaction_repo.dart';
import '../../../domain/entities/account_model.dart';
import '../../../domain/entities/transaction_model.dart';

class TransactionDetailsController extends GetxController {
  final AccountRepository _accountRepository;
  final TransactionRepository _transactionsRepository;

  TransactionDetailsController(
      this._accountRepository,
      this._transactionsRepository,
      );

  ScreenEnums popResult = ScreenEnums.none;

  ScreenEnums _screenEnum = ScreenEnums.loaded;
  ScreenEnums get screenEnum => _screenEnum;
  set screenEnum(ScreenEnums v) {
    _screenEnum = v;
    update();
  }

  AccountModel? account;
  TransactionModel? transaction;

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      screenEnum = ScreenEnums.loading;
      await Future.wait([
        getAccountData(),
        getTransaction(),
      ]);
      screenEnum = ScreenEnums.loaded;
      if (transaction == null || account == null) {
        screenEnum = ScreenEnums.error;
      }
    } else {
      screenEnum = ScreenEnums.error;
    }
  }

  Future<void> getAccountData() async {
    account = await _accountRepository.getAccount();
  }

  Future<void> getTransaction() async {
    final String id = Get.arguments as String;
    transaction = await _transactionsRepository.getTransactionsById(id);
  }

  void addReceipt() {}

  void splitThisBill() async {
    if (transaction?.price != null && transaction?.alreadySplitBefore != null) {
      if (transaction!.alreadySplitBefore!) {
        toast(StringsKeys.alreadySplitBefore.tr);
      } else {
        final double res = transaction!.price! / 2;
        transaction!.price = res;
        account!.price = account!.price! + res;
        transaction?.alreadySplitBefore = true;
        popResult = ScreenEnums.refresh;
        update();
        await _transactionsRepository.splitPayment(
          v: transaction!,
          p: TransactionModel(
            transactionId: generateId(),
            price: res,
            createdAt: getMillisecondsSinceEpochDateTime(DateTime.now()),
            type: AppValues.transactionTopUp,
          ),
          a: account!,
        );
        toast(StringsKeys.done.tr);
      }
    } else {
      toast(StringsKeys.somethingWentWrong.tr);
    }
  }

  void repeatingPayment() async {
    if (account!.price! >= transaction!.price!) {
      final bool res = !(transaction!.repeatingPayment ?? false);
      transaction!.repeatingPayment = res;
      popResult = ScreenEnums.refresh;
      account!.price = account!.price! - transaction!.price!;
      update();
      await _transactionsRepository.splitPayment(
        v: transaction!,
        p: TransactionModel(
          transactionId: generateId(),
          merchantId: transaction?.merchantId,
          merchantTitle: transaction?.merchantTitle,
          price: transaction?.price,
          createdAt: getMillisecondsSinceEpochDateTime(DateTime.now()),
          repeatingPayment: false,
          type: transaction?.type,
          alreadySplitBefore: false,
        ),
        a: account!,
      );
    } else {
      toast(StringsKeys.somethingWentWrong.tr);
    }
  }

  void getHelp() => toast(StringsKeys.helpIsOnTheWayStayPut.tr);

  Future<bool> onWillPop() async {
    Get.back(result: popResult);
    return false;
  }
}