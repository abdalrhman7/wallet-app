import 'dart:convert';

import 'package:get/get.dart';
import 'package:money_app/money/data/data_sources/local/local_storage.dart';
import 'package:money_app/money/data/data_sources/remote/repositories/transaction_repo.dart';
import 'package:money_app/money/domain/entities/account_model.dart';
import 'package:money_app/money/domain/entities/transaction_model.dart';

class TransactionsRepositoryImpl extends TransactionRepository {
  final LocalStorage _storage;

  TransactionsRepositoryImpl(this._storage);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    List<TransactionModel> res = <TransactionModel>[];
    try {
      final String? storageRes = await _storage.getTransactions();
      if (storageRes != null) {
        res = (jsonDecode(storageRes) as List)
            .map((e) => TransactionModel.fromJson(e))
            .toList();
        res.sort(
          (a, b) => a.createdAt!.compareTo(b.createdAt!),
        );
      }
    } catch (e) {
    }
    return res;
  }

  @override
  Future<TransactionModel?> getTransactionsById(String id) async {
    try {
      final List<TransactionModel> storageRes = await getTransactions();
      final TransactionModel? res =
          storageRes.firstWhereOrNull((e) => e.transactionId == id);
      return res;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> pay(
      {required TransactionModel v, required AccountModel a}) async {
    try {
      final List<TransactionModel> storageRes = await getTransactions();
      storageRes.add(v);
      List<Map<String, dynamic>> res = [];
      for (int i = 0; i < storageRes.length; i++) {
        res.add(storageRes[i].toJson());
      }
      await Future.wait([
        _storage.setTransactions(jsonEncode(res)),
        _storage.setAccount(jsonEncode(a.toJson())),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> repeatingPayment(
      {required TransactionModel v,
      required TransactionModel p,
      required AccountModel a}) async {
    try {
      final List<TransactionModel> storageRes = await getTransactions();
      storageRes.removeWhere((e) => e.transactionId == v.transactionId);
      storageRes.add(v);
      storageRes.add(p);
      List<Map<String, dynamic>> res = [];
      for (int i = 0; i < storageRes.length; i++) {
        res.add(storageRes[i].toJson());
      }
      await Future.wait([
        _storage.setTransactions(jsonEncode(res)),
        _storage.setAccount(jsonEncode(a.toJson())),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> splitPayment(
      {required TransactionModel v,
      required TransactionModel p,
      required AccountModel a}) async{
    try {
      final List<TransactionModel> storageRes = await getTransactions();
      storageRes.removeWhere((e) => e.transactionId == v.transactionId);
      storageRes.add(v);
      storageRes.add(p);
      List<Map<String, dynamic>> res = [];
      for (int i = 0; i < storageRes.length; i++) {
        res.add(storageRes[i].toJson());
      }
      await Future.wait([
        _storage.setTransactions(jsonEncode(res)),
        _storage.setAccount(jsonEncode(a.toJson())),
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
