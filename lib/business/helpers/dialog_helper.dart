import 'package:flutter/cupertino.dart';
import 'package:flutter_app_info/flutter_app_info.dart';
import 'package:pp_26/business/services/navigation/route_names.dart';

class DialogHelper {
  static Future<void> showNoInternetDialog(BuildContext context) async =>
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'You have lost your internet connection. Please check your settings and try again.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.splash,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );

  static Future<void> showErrorDialog(
          BuildContext context, String error) async =>
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(error),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.splash,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );

  static Future<void> showAppVersionDialog(BuildContext context) async {
    final info = AppInfo.of(context);
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text(info.package.appName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Operating system: ${info.platform.operatingSystem}'),
            SizedBox(height: 8),
            Text('Installer store: ${info.package.installerStore ?? '-'}'),
            SizedBox(height: 8),
            Text('Version: ${info.package.versionWithoutBuild}'),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              'OK',
              style: TextStyle().copyWith(color: CupertinoColors.activeBlue),
            ),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }

  static Future<void> showPrivacyAgreementDialog(
    BuildContext context, {
    VoidCallback? yes,
    VoidCallback? no,
  }) async {
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Dear user!'),
        content: const Text(
            'We would be very grateful if you would read the policy of our application and accept the consent. Do you want to continue?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('YES'),
            onPressed: () {
              Navigator.of(context).pop();
              yes?.call();
            },
          ),
          CupertinoDialogAction(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop();
              no?.call();
            },
          ),
        ],
      ),
    );
  }
}
