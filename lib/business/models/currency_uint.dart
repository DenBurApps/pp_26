import 'package:equatable/equatable.dart';
import 'package:pp_26/data/entity/currency_uint_entity.dart';

class CurrencyUint extends Equatable {
  final String uuid;
  final String? iconUrl;
  final String? name;
  final String? symbol;
  final String? sign;

  const CurrencyUint({
    required this.name,
    required this.symbol,
    required this.iconUrl,
    required this.sign,
    required this.uuid,
  });

  @override
  List<Object?> get props => [uuid];

  factory CurrencyUint.fromEntity(CurrencyUintEntity entity) => CurrencyUint(
    name: entity.name,
    symbol: entity.symbol,
    iconUrl: entity.iconUrl,
    sign: entity.sign,
    uuid: entity.uuid,
  );

  factory CurrencyUint.fromJson(Map<String, dynamic> json) => CurrencyUint(
    name: json['name'],
    symbol: json['symbol'],
    iconUrl: json['iconUrl'],
    sign: json['sign'],
    uuid: json['uuid'],
  );
}