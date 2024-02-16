import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_26/business/helpers/image/image_helper.dart';
import 'package:pp_26/presentation/pages/currency_view.dart';
import 'package:pp_26/presentation/pages/home_view.dart';
import 'package:pp_26/presentation/pages/settings_view.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const HomeView(),
    CurrencyView(),
    SettingsView(),
  ];

  void _navigate(int index) => setState(() {
        _currentIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 64,
        color: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NavItem(
                label: 'Home',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: _currentIndex == 0
                        ? Theme.of(context).extension<CustomColors>()!.black
                        : Theme.of(context).extension<CustomColors>()!.black),
                icon: ImageHelper.svgImage(
                  SvgNames.home,
                  color: _currentIndex == 0
                      ? Theme.of(context).extension<CustomColors>()!.black!.withOpacity(1)
                      : Theme.of(context).extension<CustomColors>()!.black!.withOpacity(0.4),
                ),
                background: _currentIndex == 0 ? Theme.of(context).colorScheme.primary : null,
                callback: () => _navigate(0),
              ),
              const SizedBox(width: 51),
              NavItem(
                label: 'Currency',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: _currentIndex == 1
                        ? Theme.of(context).extension<CustomColors>()!.black!.withOpacity(1)
                        : Theme.of(context).extension<CustomColors>()!.black!.withOpacity(0.4)),
                icon: ImageHelper.svgImage(
                  SvgNames.currency,
                  color: _currentIndex == 1
                      ? Theme.of(context).extension<CustomColors>()!.black!.withOpacity(1)
                      : Theme.of(context).extension<CustomColors>()!.black!.withOpacity(0.4),
                ),
                background: _currentIndex == 1 ? Theme.of(context).colorScheme.primary : null,
                callback: () => _navigate(1),
              ),
              const SizedBox(width: 51),
              NavItem(
                label: 'Settings',
                textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: _currentIndex == 2
                        ? Theme.of(context).extension<CustomColors>()!.black!.withOpacity(1)
                        : Theme.of(context).extension<CustomColors>()!.black!.withOpacity(0.4)),
                icon: ImageHelper.svgImage(
                  SvgNames.settings,
                  color: _currentIndex == 2
                      ? Theme.of(context).extension<CustomColors>()!.black!.withOpacity(1)
                      : Theme.of(context).extension<CustomColors>()!.black!.withOpacity(0.4),
                ),
                background: _currentIndex == 2 ? Theme.of(context).colorScheme.primary : null,
                callback: () => _navigate(2),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.label,
    required this.icon,
    required this.callback,
    required this.textStyle,
    this.background,
  });

  final VoidCallback callback;
  final String label;
  final Widget icon;
  final TextStyle textStyle;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => callback.call(),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          icon,
          const SizedBox(height: 2),
          Text(
            label,
            style: textStyle,
          )
        ],
      ),
    );
  }
}
