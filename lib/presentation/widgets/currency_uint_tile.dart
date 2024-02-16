import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_26/business/models/currency_uint.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';

class CurrencyUintTile extends StatelessWidget {
  final CurrencyUint currency;
  final bool isSelected;
  final bool isLoadingRates;
  final VoidCallback? onPressed;
  final String relativeRate;

  CurrencyUintTile({
    required this.currency,
    required this.isSelected,
    required this.isLoadingRates,
    this.onPressed,
    required this.relativeRate,
  });

  int limit = 15;

  @override
  Widget build(BuildContext context) {
    String currencyName = currency.name ?? '';
    String strictedCurrency =
        currencyName.length > limit ? currencyName.substring(0, limit) : currencyName;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).extension<CustomColors>()!.walletBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3B363F),
              ),
              child: Center(
                child: Text(
                  currency.sign ?? '\$',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              currency.symbol!,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            isLoadingRates
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).extension<CustomColors>()!.background,
                    ),
                  )
                : Text(
                    relativeRate,
                    style: GoogleFonts.syne(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.onPrimary),
                  )
          ],
        ),
      ),
    );
  }
}
