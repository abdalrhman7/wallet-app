import 'package:money_app/money/domain/entities/account_model.dart';
import 'package:money_app/money/domain/entities/transaction_model.dart';

abstract class TransactionRepository{
  Future<List<TransactionModel?>> getTransactions();


  Future<TransactionModel?> getTransactionsById(final String id);

 Future<bool> pay({
   required final TransactionModel v,
   required final AccountModel a ,
});

 Future<bool> repeatingPayment({
required final TransactionModel v ,
required final TransactionModel p ,
required final AccountModel a ,
});

 Future<bool> splitPayment({
required final TransactionModel v ,
required final TransactionModel p ,
required final AccountModel a ,
});
}