import 'package:flutter/cupertino.dart';
import 'package:pp_26/business/services/navigation/route_names.dart';
import 'package:pp_26/presentation/pages/agreement_view.dart';
import 'package:pp_26/presentation/pages/home_view.dart';
import 'package:pp_26/presentation/pages/main_screen_view.dart';
import 'package:pp_26/presentation/pages/onboarding_view.dart';
import 'package:pp_26/presentation/pages/privacy_view.dart';
import 'package:pp_26/presentation/pages/splash_view.dart';
import 'package:pp_26/presentation/pages/support_view.dart';

typedef ScreenBuilding = Widget Function(BuildContext context);

class Routes {
  static Map<String, ScreenBuilding> get(BuildContext context) {
    return {
      RouteNames.splash: (context) => const SplashView(),
      RouteNames.main: (context) => const MainScreen(),
      RouteNames.home: (context) => const HomeView(),
      RouteNames.onboarding: (context) => const OnboardingView(),
      RouteNames.agreement: (context) {
        final arg = ModalRoute.of(context)!.settings.arguments as AgreementType;
        return AgreementView(agreementType: arg);
      },
      RouteNames.support: (context) => const SupportView(),
      RouteNames.privacy: (context) => const PrivacyView(),
    };
  }
}
