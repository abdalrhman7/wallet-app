import 'package:money_app/money/domain/entities/account_model.dart';

abstract class AccountRepository{
Future<AccountModel?> getAccount();
Future<AccountModel?> createAccount();
}