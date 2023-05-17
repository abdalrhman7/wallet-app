import 'dart:convert';


import '../../data/data_sources/local/local_storage.dart';
import '../../data/data_sources/remote/repositories/account_repository.dart';
import '../entities/account_model.dart';

class AccountRepositoryImpl extends AccountRepository {
  final LocalStorage _storage;

  AccountRepositoryImpl(
      this._storage,
      );

  @override
  Future<AccountModel?> createAccount() async {
    try {
      final account = AccountModel(price: 0.0);
      await _storage.setAccount(
        jsonEncode(account.toJson()),
      );
      return account;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AccountModel?> getAccount() async {
    AccountModel? res;

    try {
      final String? storageRes = await _storage.getAccount();
      if (storageRes == null) {
        res = await createAccount();
      } else {
        final Map<String, dynamic> locMap = jsonDecode(storageRes);
        res = AccountModel.fromJson(locMap);
      }
    } catch (e) {
    }
    return res;
  }
}
