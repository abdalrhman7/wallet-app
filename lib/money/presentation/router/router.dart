import 'package:get/get.dart';
import 'package:money_app/money/presentation/router/routes.dart';

import '../../../shared/utils/utils.dart';
import '../di/pay_binding.dart';
import '../di/splash_binding.dart';
import '../di/transaction_details_binding.dart';
import '../di/transactions_binding.dart';
import '../ui/pay/pay_screen.dart';
import '../ui/splash/splash_screen.dart';
import '../ui/transaction_details/transaction_details_screen.dart';
import '../ui/transactions/transactions_screen.dart';


class AppRouter {
  static Transition? _transition() => isMobile() ? null : Transition.fadeIn;


  static final List<GetPage> routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: _transition(),
    ),
    GetPage(
      name: AppRoutes.transactions,
      page: () => const TransactionsScreen(),
      binding: TransactionsBinding(),
      transition: _transition(),
    ),
    GetPage(
      name: AppRoutes.pay,
      page: () => const PayScreen(),
      binding: PayBinding(),
      transition: _transition(),
    ),
    GetPage(
      name: AppRoutes.transactionDetails,
      page: () => const TransactionDetailsScreen(),
      binding: TransactionDetailsBinding(),
      transition: _transition(),
    ),
  ];

}
