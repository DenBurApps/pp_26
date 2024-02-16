import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_26/business/models/currency_uint.dart';
import 'package:pp_26/business/services/currency_service.dart';
import 'package:pp_26/business/services/exchange_currency_api_service.dart';
import 'package:pp_26/data/entity/currency_uint_entity.dart';
import 'package:pp_26/data/repository/database_keys.dart';
import 'package:pp_26/data/repository/database_service.dart';

class CurrencySelectionController extends ValueNotifier<CurrencySelectionState> {
  CurrencySelectionController() : super(CurrencySelectionState.inital()) {
    _init();
  }

  final _cryptoApiService = GetIt.instance<CurrencyService>();
  final _databaseService = GetIt.instance<DatabaseService>();
  final exchangeCurrencyApiService = GetIt.instance.get<ExchangeCurrencyApiService>();

  Future<void> _init() async {
    try {
      value = value.copyWith(isLoading: true);
      final currencyUints = await _cryptoApiService.getCurrencyUints();
      value = value.copyWith(
        currencyUints: currencyUints,
        isLoading: false,
        selectedCurrency: currencyUints.first,
      );
      notifyListeners();
      initRates();
    } catch (e) {
      log(e.toString());
      value = value.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void refresh() => _init();

  void saveCurrencyUint() {
    _databaseService.putCurrencyUint(
      DatabaseKeys.defaultCurrency,
      CurrencyUintEntity.fromOriginal(value.selectedCurrency!),
    );
  }

  Future<void> initRates() async{
    var currencyRates = <double>[];
    value = value.copyWith(isLoadingRates: true);
    notifyListeners();
    for (var currency in value.currencyUints) {
      if (value.selectedCurrency?.symbol == currency.symbol) {
        currencyRates.add(10.0);
      } else {
        try {
          var indexedRate = await exchangeCurrencyApiService.getExchangeRate(
            from: value.selectedCurrency?.symbol ?? 'USD',
            to: currency.symbol ?? 'GBP',
            amount: '10',
          );
          currencyRates.add(indexedRate ?? -100.0);
        } catch (e) {
          var indexedRate = -1.0;
          currencyRates.add(indexedRate);
          print('An error occurred: $e');
        }

      }
    }
    value = value.copyWith(currencyRates: currencyRates, currencyUints: value.currencyUints, isLoading: false, isLoadingRates: false);
    notifyListeners();
  }

  void selectCurrency(CurrencyUint currency) {
    value = value.copyWith(selectedCurrency: currency, currencyUints: value.currencyUints);
    notifyListeners();
    initRates();
  }
}

class CurrencySelectionState {
  final List<CurrencyUint> currencyUints;
  final CurrencyUint? selectedCurrency;
  final bool isLoading;
  final bool isLoadingRates;
  final String? errorMessage;
  final List<double>? currencyRates;

  const CurrencySelectionState({
    required this.currencyUints,
    required this.isLoading,
    required this.isLoadingRates,
    this.errorMessage,
    this.selectedCurrency,
    this.currencyRates,
  });

  factory CurrencySelectionState.inital() => const CurrencySelectionState(
        currencyUints: [],
        isLoading: false,
        isLoadingRates: false,
        currencyRates: [],
      );

  CurrencySelectionState copyWith({
    List<CurrencyUint>? currencyUints,
    bool? isLoading,
    bool? isLoadingRates,
    String? errorMessage,
    CurrencyUint? selectedCurrency,
    List<double>? currencyRates,
  }) =>
      CurrencySelectionState(
        currencyUints: currencyUints ?? this.currencyUints,
        isLoading: isLoading ?? this.isLoading,
        isLoadingRates: isLoadingRates ?? this.isLoadingRates,
        errorMessage: errorMessage ?? this.errorMessage,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
        currencyRates: currencyRates ?? this.currencyRates,
      );
}
