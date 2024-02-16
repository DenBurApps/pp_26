import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_26/business/helpers/email_helper.dart';
import 'package:pp_26/business/helpers/image/image_helper.dart';
import 'package:pp_26/business/services/navigation/route_names.dart';
import 'package:pp_26/presentation/pages/agreement_view.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';
import 'package:pp_26/presentation/widgets/app_button.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final feedbackController = TextEditingController();

  void _showDialog({required String text, required bool isDone}) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).extension<CustomColors>()!.background,
              ),
              height: 200,
              width: 200,
              child: Center(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: isDone
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).extension<CustomColors>()!.goalStepper,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        });
  }

  void _sendMessage() {
    EmailHelper.launchEmailSubmission(
      toEmail: '',
      subject: 'Connect with support',
      body: feedbackController.text,
      errorCallback: () => _showDialog(text: 'Error', isDone: false),
      doneCallback: () => _showDialog(text: 'Thank you for feedback!', isDone: true),
    );
  }

  void _navigateTerms(context) =>
      Navigator.of(context).pushNamed(RouteNames.agreement, arguments: AgreementType.terms);

  void _navigatePrivacy(context) =>
      Navigator.of(context).pushNamed(RouteNames.agreement, arguments: AgreementType.privacy);

  void _openContacts(context) {
    showCupertinoModalPopup(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                    const SizedBox(width: 50),
                    Text('Contact Developer', style: Theme.of(context).textTheme.labelMedium,),
                    const Spacer(),
                    CupertinoButton(child: const Icon(Icons.close, color: Color(0xFF0A191E),), onPressed: () => Navigator.of(context).pop())
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text('Write anything you want to tell us about', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    controller: feedbackController,
                    maxLength: 8,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemFill,
                        borderRadius: BorderRadius.circular(10)),
                    placeholder: 'Send your message',
                    placeholderStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color:
                            Theme.of(context).extension<CustomColors>()!.label!.withOpacity(0.6)),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).extension<CustomColors>()!.label),
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    name: 'Send',
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    width: double.infinity,
                    callback: _sendMessage,
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).extension<CustomColors>()!.background,
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Settings',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              const SizedBox(height: 80),
              SettingsItem(
                  icon: ImageHelper.svgImage(SvgNames.share, width: 26, height: 26),
                  label: 'Share app',
                  callback: () {}),
              const SizedBox(height: 10),
              SettingsItem(
                  icon: ImageHelper.svgImage(SvgNames.lock, width: 26, height: 26),
                  label: 'Privacy Policy',
                  callback: () => _navigatePrivacy(context)),
              const SizedBox(height: 10),
              SettingsItem(
                  icon: ImageHelper.svgImage(SvgNames.key, width: 26, height: 26),
                  label: 'Terms of use',
                  callback: () => _navigateTerms(context)),
              const SizedBox(height: 10),
              SettingsItem(
                  icon: ImageHelper.svgImage(SvgNames.calling, width: 26, height: 26),
                  label: 'Contact Developer',
                  callback: () => _openContacts(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({super.key, required this.icon, required this.label, required this.callback});

  final Widget icon;
  final String label;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).extension<CustomColors>()!.background,
          border: Border.all(color: const Color(0xFFF2F2F2)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 20),
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
            const Spacer(),
            Icon(
              CupertinoIcons.chevron_forward,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            ),
            const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}
