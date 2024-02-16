import 'package:get_it/get_it.dart';
import 'package:pp_26/business/services/currency_service.dart';
import 'package:pp_26/business/services/exchange_currency_api_service.dart';
import 'package:pp_26/business/services/remote_config_service.dart';
import 'package:pp_26/data/repository/database_service.dart';
import 'package:pp_26/presentation/controllers/currency_controller.dart';

class ServiceLocator {
  static Future<void> setup() async {
    GetIt.I.registerSingletonAsync<DatabaseService>(() => DatabaseService().init());
    await GetIt.I.isReady<DatabaseService>();
    GetIt.I.registerSingletonAsync<RemoteConfigService>(() => RemoteConfigService().init());
    await GetIt.I.isReady<RemoteConfigService>();
    GetIt.I.registerSingleton<ExchangeCurrencyApiService>(ExchangeCurrencyApiService());
    GetIt.I.registerSingleton<CurrencyService>(CurrencyService());
    GetIt.I.registerSingleton<CurrencySelectionController>(CurrencySelectionController());
  }
}
