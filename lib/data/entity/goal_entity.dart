import 'package:hive/hive.dart';

part 'goal_entity.g.dart';

@HiveType(typeId: 2)
class Goal extends HiveObject{
  @HiveField(0)
  late final String name;
  @HiveField(1)
  late final double amount;
  @HiveField(2)
  late final double amountAccumulated;
  @HiveField(3)
  late final DateTime dateTimeCreate;
  @HiveField(4)
  late final DateTime dateTimeExpire;

  Goal({
    required this.name,
    required this.amount,
    required this.amountAccumulated,
    required this.dateTimeCreate,
    required this.dateTimeExpire,
  });

  Goal copyWith({
    String? name,
    double? amount,
    double? amountAccumulated,
    DateTime? dateTimeCreate,
    DateTime? dateTimeExpire,
  }) =>
      Goal(
        name: name ?? this.name,
        amount: amount ?? this.amount,
        amountAccumulated: amountAccumulated ?? this.amountAccumulated,
        dateTimeCreate: dateTimeCreate ?? this.dateTimeCreate,
        dateTimeExpire: dateTimeExpire ?? this.dateTimeExpire,
      );
}
