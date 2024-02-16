import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pp_26/business/helpers/email_helper.dart';
import 'package:pp_26/business/helpers/text_helper.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';

class AgreementView extends StatelessWidget {
  const AgreementView({super.key, required this.agreementType});

  final AgreementType agreementType;

  String get _agreementText =>
      agreementType == AgreementType.privacy ? TextHelper.privacy : TextHelper.terms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: Navigator.of(context).pop,
                    child: SizedBox(
                      width: 8,
                      height: 15,
                      child: Icon(
                        CupertinoIcons.chevron_back,
                        color: Theme.of(context).extension<CustomColors>()!.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        agreementType == AgreementType.privacy ? 'Privacy Policy' : 'Terms of use',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: MarkdownBody(
                    data: _agreementText,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                      p: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      a: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      code: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      checkbox:
                          TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      h1: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      h2: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      h3: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      h4: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      em: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      del: TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                      listBullet:
                          TextStyle(color: Theme.of(context).extension<CustomColors>()!.black),
                    ),
                    onTapLink: (text, href, title) => EmailHelper.launchEmailSubmission(
                      toEmail: text,
                      subject: '',
                      body: '',
                      errorCallback: () {},
                      doneCallback: () {},
                    ),
                    selectable: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AgreementType {
  privacy,
  terms,
}
