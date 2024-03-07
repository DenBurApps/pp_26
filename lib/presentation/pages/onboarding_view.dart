import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_26/business/helpers/dialog_helper.dart';
import 'package:pp_26/business/helpers/image/image_helper.dart';
import 'package:pp_26/business/services/navigation/route_names.dart';
import 'package:pp_26/data/repository/database_keys.dart';
import 'package:pp_26/data/repository/database_service.dart';
import 'package:pp_26/models/arguements.dart';
import 'package:pp_26/presentation/pages/agreement_view.dart';
import 'package:pp_26/presentation/widgets/app_button.dart';
import 'package:pp_26/presentation/widgets/step_divider.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _databaseService = GetIt.instance<DatabaseService>();

  int currentStep = 0;

  final images = [
    ImageHelper.getImage(ImageNames.onb1),
    ImageHelper.getImage(ImageNames.onb2),
    ImageHelper.getImage(ImageNames.onb3),
  ];

  final title = [
    'Add Some Credit\nTo Your Card',
    'Set goals and get results!',
    'Check all ranges!',
  ];

  final desc = [
    'Welcome to the app that changes the way you think about saving!',
    'Convenient tracking: Track your income and expenses, as well as see how your savings accumulate over time.',
    'Save money and track your savings!',
  ];

  void _increaseStep() {
    if (currentStep == 2) {
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
      setState(() {
        currentStep += 1;
      });
    }
  }

  void _decreaseStep() {
    if (currentStep == 0) {
      return;
    }
    setState(() {
      currentStep -= 1;
    });
  }

  void _init() {
    _databaseService.put(DatabaseKeys.seenOnboarding, true);
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: images[currentStep].image,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              StepDivider(
                fillPercentage:
                    currentStep == 0 ? 0 : 100 - (100 / currentStep).round(),
                width: double.infinity,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                filledColor: Theme.of(context).colorScheme.onBackground,
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      title[currentStep],
                      style: GoogleFonts.syne(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      desc[currentStep],
                      style: GoogleFonts.syne(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 38),
                    currentStep == 2
                        ? AppButton(
                            name: 'Get started',
                            textColor: Colors.white,
                            callback: _increaseStep,
                            width: 136,
                          )
                        : Row(
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: _decreaseStep,
                                child: ImageHelper.svgImage(SvgNames.onbPrev),
                              ),
                              const Spacer(),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: _increaseStep,
                                child: ImageHelper.svgImage(SvgNames.onbNext),
                              )
                            ],
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
