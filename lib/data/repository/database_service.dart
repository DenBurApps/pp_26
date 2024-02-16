import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pp_26/data/entity/currency_uint_entity.dart';
import 'package:pp_26/data/entity/goal_entity.dart';
import 'package:pp_26/data/entity/transaction_entity.dart';
import 'package:pp_26/data/entity/wallet_entity.dart';
import 'package:pp_26/data/repository/database_keys.dart';


class DatabaseService {
  late final Box<dynamic> _common;
  late final Box<Transaction> _transactions;
  late final Box<CurrencyUintEntity> _defaultCurrency;
  late final Box<Goal> _goals;
  late final Box<WalletEntity> _wallet;

  Future<DatabaseService> init() async {
    await Hive.initFlutter();
    final appDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDirectory.path);

    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(WalletEntityAdapter());

    _common = await Hive.openBox('_common');
    _transactions = await Hive.openBox('_transactions');
    _defaultCurrency = await Hive.openBox('defaultCurrency');
    _goals = await Hive.openBox('_goals');
    _wallet = await Hive.openBox('_wallet');

    setupWallet();

    return this;
  }


  void setupWallet() {
    if (_wallet.isEmpty) {
      _wallet.put('_myWallet', WalletEntity(balance: 0));
    }
  }

  bool get isCurrencyUintEmpty => getCurrencyUint(DatabaseKeys.defaultCurrency) == null;

  CurrencyUintEntity? getCurrencyUint(String key) => _defaultCurrency.get(key);

  void putCurrencyUint(String key, CurrencyUintEntity value) => _defaultCurrency.put(key, value);

  void put(String key, dynamic value) => _common.put(key, value);

  dynamic get(String key) => _common.get(key);

  WalletEntity getWallet() => _wallet.get('_myWallet')!;

  void createTransaction(Transaction transaction) => _transactions.put(transaction.name, transaction);

  Transaction? getTransaction({required String name}) => _transactions.get(name);

  List<Transaction> get transactions => _transactions.values.toList();

  void removeTransaction({required String name}) => _transactions.delete(name);

  Goal? getGoal({required String name}) => _goals.get(name);

  List<Goal> get goals => _goals.values.toList();

  void createGoal(Goal goal) => _goals.put(goal.name, goal);

  void removeGoal({required String name}) => _goals.delete(name);

  void updateWallet({required WalletEntity newWallet}) {
    _wallet.delete('_myWallet');
    _wallet.put('_myWallet', newWallet);
  }

  void addWalletMoney({required double amount}) {
    var wallet = getWallet();
    final walletBalance = wallet.balance;
    wallet = wallet.copyWith(balance: walletBalance + amount);
    updateWallet(newWallet: wallet);
  }

  void removeWalletMoney({required double amount}) {
    var wallet = getWallet();
    final walletBalance = wallet.balance;
    wallet = wallet.copyWith(balance: walletBalance - amount);
    updateWallet(newWallet: wallet);
  }

  void addMoneyToGoal({required Goal goal, required double amount}) {
    var editedAmount = goal.amountAccumulated + amount;
    var selectedGoal = getGoal(name: goal.name);
    selectedGoal = selectedGoal!.copyWith(amountAccumulated: editedAmount);
    removeGoal(name: goal.name);
    createGoal(selectedGoal);
    removeWalletMoney(amount: amount);
  }

  void removeMoneyFromGoal({required Goal goal, required double amount}) {
    var editedAmount = goal.amountAccumulated - amount;
    var selectedGoal = getGoal(name: goal.name);
    selectedGoal = selectedGoal!.copyWith(amountAccumulated: editedAmount);
    removeGoal(name: goal.name);
    createGoal(selectedGoal);
    addWalletMoney(amount: amount);
  }
}
