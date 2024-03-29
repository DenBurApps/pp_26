import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_26/business/helpers/dialog_helper.dart';
import 'package:pp_26/business/services/navigation/route_names.dart';
import 'package:pp_26/business/services/remote_config_service.dart';
import 'package:pp_26/data/repository/database_keys.dart';
import 'package:pp_26/data/repository/database_service.dart';
import 'package:pp_26/models/arguements.dart';
import 'package:pp_26/presentation/pages/agreement_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _remoteConfigService = GetIt.instance<RemoteConfigService>();
  final _databaseService = GetIt.instance<DatabaseService>();
  final _connectivity = Connectivity();

  late bool usePrivacyAgreement;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await _initConnectivity(
      () async => await DialogHelper.showNoInternetDialog(context),
    );
    usePrivacyAgreement = _remoteConfigService.getBool(ConfigKey.usePrivacy);
    _navigate();
  }

  Future<void> _initConnectivity(Future<void> Function() callback) async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        await callback.call();
        return;
      }
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }
  }

  void _navigate() {
    if (usePrivacyAgreement) {
      final seenOnboarding =
          _databaseService.get(DatabaseKeys.seenOnboarding) ?? false;
      if (!seenOnboarding) {
        Navigator.of(context).pushReplacementNamed(RouteNames.onboarding);
      } else {
        final seenPrivacyAgreement =
            _databaseService.get(DatabaseKeys.seenPrivacyAgreement) ?? false;
        if (!seenPrivacyAgreement) {
          _databaseService.put(DatabaseKeys.seenPrivacyAgreement, true);
          DialogHelper.showPrivacyAgreementDialog(
            context,
            yes: () => Navigator.of(context).pushReplacementNamed(
              RouteNames.agreement,
              arguments: AgreementViewArguments(
                agreementType: AgreementType.privacy,
                userPrivacyAgreement: true,
              ),
            ),
            no: () => Navigator.of(context).pushReplacementNamed(
              RouteNames.main,
            ),
          );
        } else {
          Navigator.of(context).pushReplacementNamed(RouteNames.main);
        }
      }
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.privacy);
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
