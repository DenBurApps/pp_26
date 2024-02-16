import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_26/business/helpers/image/image_helper.dart';
import 'package:pp_26/business/models/currency_uint.dart';
import 'package:pp_26/business/services/exchange_currency_api_service.dart';
import 'package:pp_26/presentation/controllers/currency_controller.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';
import 'package:pp_26/presentation/widgets/currency_uint_tile.dart';

class CurrencyView extends StatelessWidget {
  CurrencyView({super.key});

  final _currencySelectionController = GetIt.instance.get<CurrencySelectionController>();
  final exchangeCurrencyApiService = GetIt.instance.get<ExchangeCurrencyApiService>();

  void _selectCurrency(CurrencyUint currencyUint, BuildContext context) {
    _currencySelectionController.selectCurrency(currencyUint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _currencySelectionController,
          builder: (BuildContext context, CurrencySelectionState value, Widget? child) {
            if (value.isLoading) {
              return const _LoadingState();
            } else if (value.errorMessage != null) {
              return _ErrorState(
                refresh: _currencySelectionController.refresh,
                error: 'Some error has occured.\nPlease, try again!',
              );
            } else {
              final currencies = value.currencyUints;

              return Container(
                padding: const EdgeInsets.all(20),
                color: Theme.of(context).extension<CustomColors>()!.background,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Currency',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your currency',
                        style: GoogleFonts.syne(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      const SizedBox(height: 15),
                      CurrencyUintTile(
                        currency: value.selectedCurrency ?? currencies[0],
                        isSelected: true,
                        onPressed: null,
                        isLoadingRates: false,
                        relativeRate: '10',
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Exchange rates',
                        style: GoogleFonts.syne(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final currency = currencies[index];
                            return CurrencyUintTile(
                              currency: currency,
                              isSelected: currency == value.selectedCurrency,
                              onPressed: () => _selectCurrency(currency, context),
                              // relativeRate: '10',
                              isLoadingRates: value.isLoadingRates,
                              relativeRate: '${index <= value.currencyRates!.length - 1 ? value.currencyRates![index] : -10.10}',
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemCount: currencies.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(radius: 10),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback refresh;
  final String error;

  const _ErrorState({required this.refresh, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: refresh,
            color: Theme.of(context).extension<CustomColors>()!.black,
            child: const Icon(Icons.replay_circle_filled_rounded),
          ),
        ],
      ),
    );
  }
}
