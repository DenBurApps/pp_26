import 'package:hive/hive.dart';

part 'transaction_entity.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject{
  @HiveField(0)
  late final String name;
  @HiveField(1)
  late final double amount;
  @HiveField(2)
  late final DateTime dateTime;

  Transaction({
    required this.name,
    required this.amount,
    required this.dateTime,
  });

  Transaction copyWith({
    String? name,
    double? amount,
    DateTime? dateTime,
  }) =>
      Transaction(
        name: name ?? this.name,
        amount: amount ?? this.amount,
        dateTime: dateTime ?? this.dateTime,
      );
}
