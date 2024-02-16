import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_26/business/helpers/dialog_helper.dart';
import 'package:pp_26/data/entity/goal_entity.dart';
import 'package:pp_26/data/entity/transaction_entity.dart';
import 'package:pp_26/data/repository/database_service.dart';

class WalletController extends ValueNotifier<WalletControllerState> {
  WalletController() : super(WalletControllerState.initial()) {
    initialize();
  }

  final dataBase = GetIt.instance.get<DatabaseService>();

  void initialize() {
    final transactions = dataBase.transactions;
    final goals = dataBase.goals;
    final wallet = dataBase.getWallet();
    value = value.copyWith(transactions: transactions, goals: goals, balance: wallet.balance);
    notifyListeners();
  }

  bool addMoneyToGoal({required Goal goal, required double amount, required BuildContext context}) {
    final wallet = dataBase.getWallet();
    final balance = wallet.balance;

    if (amount < 0) {
      DialogHelper.showErrorDialog(context, 'You cannot create a transaction with negative balance!');
      return false;
    }

    if (balance < amount) {
      DialogHelper.showErrorDialog(context, 'Not enough funds in the balance to replenish the target');
      return false;
    } else {
      if (goal.amountAccumulated + amount > goal.amount) {
        DialogHelper.showErrorDialog(context, 'The target is full, you can only add ${goal.amount - goal.amountAccumulated}');
        return false;
      } else {
        dataBase.addMoneyToGoal(goal: goal, amount: amount);
        initialize();
        notifyListeners();
        return true;
      }
    }
  }

  bool removeMoneyFromGoal({required Goal goal, required double amount, required BuildContext context}) {
    final wallet = dataBase.getWallet();
    final balance = wallet.balance;

    if (amount < 0) {
      DialogHelper.showErrorDialog(context, 'You cannot create a transaction with negative balance!');
      return false;
    }

    if (amount > goal.amountAccumulated) {
      DialogHelper.showErrorDialog(context, 'Not enough funds in the goal to withdraw it!');
      return false;
    } else {
      if (goal.amountAccumulated - amount < 0) {
        DialogHelper.showErrorDialog(context, 'The target is going negative, you can only withdraw ${goal.amountAccumulated}');
        return false;
      } else {
        dataBase.removeMoneyFromGoal(goal: goal, amount: amount);
        initialize();
        notifyListeners();
        return true;
      }
    }
  }

  void createGoal({required Goal goal}) {
    dataBase.createGoal(goal);
    notifyListeners();
    initialize();
  }

  void editGoal({required Goal goal, required Goal editedGoal}) {
    dataBase.removeGoal(name: goal.name);
    dataBase.createGoal(editedGoal);
    notifyListeners();
    initialize();
  }

  void deleteGoal({required name}) {
    dataBase.removeGoal(name: name);
    notifyListeners();
    initialize();
  }

  void createTransaction({required Transaction transaction}) {
    dataBase.createTransaction(transaction);
    dataBase.addWalletMoney(amount: transaction.amount);
    notifyListeners();
    initialize();
  }

  void editTransaction({required Transaction transaction, required Transaction editedTransaction}) {
    dataBase.removeTransaction(name: transaction.name);
    dataBase.createTransaction(editedTransaction);
    notifyListeners();
    initialize();
  }

  void deleteTransaction({required Transaction transaction}) {
    dataBase.removeTransaction(name: transaction.name);
    dataBase.removeWalletMoney(amount: transaction.amount);
    notifyListeners();
    initialize();
  }
}

class WalletControllerState {
  final List<Transaction> transactions;
  final List<Goal> goals;
  final double balance;

  WalletControllerState({
    required this.transactions,
    required this.goals,
    required this.balance,
  });

  factory WalletControllerState.initial() {
    return WalletControllerState(
      transactions: [],
      goals: [],
      balance: 0,
    );
  }

  WalletControllerState copyWith({
    List<Transaction>? transactions,
    List<Goal>? goals,
    double? balance,
  }) {
    return WalletControllerState(
      transactions: transactions ?? this.transactions,
      goals: goals ?? this.goals,
      balance: balance ?? this.balance,
    );
  }
}
