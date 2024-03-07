import 'package:pp_26/presentation/pages/agreement_view.dart';

class AgreementViewArguments {
  final AgreementType agreementType;
  final bool userPrivacyAgreement;

  AgreementViewArguments({
    required this.agreementType,
    this.userPrivacyAgreement = false,
  });
}
