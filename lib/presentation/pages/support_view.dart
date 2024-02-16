import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_26/business/helpers/email_helper.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final _messageController = TextEditingController();

  var _isButtonEnabled = false;

  Future<void> _send() async => await EmailHelper.launchEmailSubmission(
        toEmail: 'ksuvei@finconte.site',
        subject: 'App Feedback',
        body: _messageController.text,
        errorCallback: () {},
        doneCallback: () => setState(() {
          _messageController.clear();
          _isButtonEnabled = false;
        }),
      );

  void _onChanged(String value) => setState(
        () => _isButtonEnabled = _messageController.text.isNotEmpty,
      );

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

