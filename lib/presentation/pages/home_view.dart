import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_26/business/helpers/date_parser.dart';
import 'package:pp_26/business/helpers/image/image_helper.dart';
import 'package:pp_26/business/models/currency_uint.dart';
import 'package:pp_26/data/entity/goal_entity.dart';
import 'package:pp_26/data/entity/transaction_entity.dart';
import 'package:pp_26/data/repository/database_service.dart';
import 'package:pp_26/presentation/controllers/currency_controller.dart';
import 'package:pp_26/presentation/controllers/wallet_controller.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';
import 'package:pp_26/presentation/widgets/app_button.dart';
import 'package:pp_26/presentation/widgets/step_divider.dart';

enum Tab { savings, goals }

enum Mode { add, edit, delete }

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Tab _selectedSegment = Tab.savings;

  final ExpandableController controller = ExpandableController();
  final currencyController = GetIt.instance.get<CurrencySelectionController>();

  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController countFieldController = TextEditingController();
  DateTime _dateTime = DateTime.now();

  late final WalletController walletController;
  final dataBase = GetIt.instance.get<DatabaseService>();

  void setDateTime(DateTime newDateTime) {
    setState(() {
      _dateTime = newDateTime;
    });
  }

  void save(Tab tab) {
    if (tab == Tab.savings) {
      walletController.createTransaction(
          transaction: Transaction(
        name: nameFieldController.text,
        amount: double.parse(countFieldController.text),
        dateTime: _dateTime,
      ));
    } else {
      walletController.createGoal(
          goal: Goal(
        name: nameFieldController.text,
        amount: double.parse(countFieldController.text),
        amountAccumulated: 0,
        dateTimeCreate: DateTime.now(),
        dateTimeExpire: _dateTime,
      ));
    }
    Navigator.of(context).pop();
  }

  void openEditMenu({required Transaction transaction, required Tab tab, required Goal goal}) {
    var showedDateTime = DateTime.now();
    nameFieldController.text = tab == Tab.savings ? transaction.name : goal.name;
    countFieldController.text =
        tab == Tab.savings ? transaction.amount.toString() : goal.amount.toString();
    _dateTime = tab == Tab.savings ? transaction.dateTime : goal.dateTimeExpire;
    showCupertinoModalPopup(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: ImageHelper.svgImage(SvgNames.cupSheet)),
                const SizedBox(height: 14),
                Text('Edit ${tab == Tab.savings ? 'saving' : 'goal'}',
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 48),
                CupertinoTextField(
                  controller: nameFieldController,
                  maxLength: 16,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemFill,
                      borderRadius: BorderRadius.circular(10)),
                  placeholder: 'Enter the name',
                  placeholderStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).extension<CustomColors>()!.label!.withOpacity(0.6)),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).extension<CustomColors>()!.label),
                ),
                const SizedBox(height: 20),
                CupertinoTextField(
                  controller: countFieldController,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemFill,
                      borderRadius: BorderRadius.circular(10)),
                  placeholder: 'Enter the counts',
                  placeholderStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).extension<CustomColors>()!.label!.withOpacity(0.6)),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).extension<CustomColors>()!.label),
                ),
                const SizedBox(height: 20),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _showDateTimeDialog(
                      CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.dateAndTime,
                        use24hFormat: true,
                        showDayOfWeek: false,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            showedDateTime = newDate;
                          });
                          setDateTime(newDate);
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                      color: CupertinoColors.secondarySystemFill,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${showedDateTime.day}.${showedDateTime.month}.${showedDateTime.year} ${showedDateTime.hour}:${showedDateTime.minute}',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context)
                                  .extension<CustomColors>()!
                                  .label!
                                  .withOpacity(0.6)),
                        ),
                        const Spacer(),
                        ImageHelper.svgImage(SvgNames.calendar, width: 20, height: 20)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    nameFieldController.text.isNotEmpty && countFieldController.text.isNotEmpty
                        ? ImageHelper.svgImage(SvgNames.radioInline)
                        : ImageHelper.svgImage(SvgNames.radioOutline),
                    const SizedBox(width: 8),
                    Text('Complete', style: Theme.of(context).textTheme.bodyLarge)
                  ],
                ),
                const Spacer(),
                AppButton(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  width: 136,
                  callback: nameFieldController.text.isNotEmpty
                      ? countFieldController.text.isNotEmpty
                          ? () {
                              if (tab == Tab.savings) {
                                walletController.editTransaction(
                                    transaction: transaction,
                                    editedTransaction: Transaction(
                                        name: nameFieldController.text,
                                        amount: double.parse(countFieldController.text),
                                        dateTime: _dateTime));
                              } else {
                                walletController.editGoal(
                                    goal: goal,
                                    editedGoal: Goal(
                                      name: nameFieldController.text,
                                      amount: double.parse(countFieldController.text),
                                      dateTimeExpire: _dateTime,
                                      dateTimeCreate: goal.dateTimeCreate,
                                      amountAccumulated: goal.amountAccumulated,
                                    ));
                              }
                              Navigator.of(context).pop();
                            }
                          : null
                      : null,
                  name: 'Save',
                  textColor: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(height: 20)
              ],
            ),
          );
        });
      },
    );
  }

  void openWalletMenu({required mode, required tab}) {
    var showedDateTime = DateTime.now();

    //add
    if (mode == Mode.add) {
      showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: ImageHelper.svgImage(SvgNames.cupSheet)),
                  const SizedBox(height: 14),
                  Text(
                      mode == Mode.add
                          ? tab == Tab.savings
                              ? 'Add savings'
                              : 'Add goals'
                          : mode == Mode.edit
                              ? tab == Tab.savings
                                  ? 'Edit savings'
                                  : 'Edit goals'
                              : tab == Tab.savings
                                  ? 'Delete savings'
                                  : 'Delete goals',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 48),
                  CupertinoTextField(
                    controller: nameFieldController,
                    maxLength: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemFill,
                        borderRadius: BorderRadius.circular(10)),
                    placeholder: 'Enter the name',
                    placeholderStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color:
                            Theme.of(context).extension<CustomColors>()!.label!.withOpacity(0.6)),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).extension<CustomColors>()!.label),
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    controller: countFieldController,
                    maxLength: 8,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemFill,
                        borderRadius: BorderRadius.circular(10)),
                    placeholder: 'Enter the counts',
                    keyboardType: TextInputType.number,
                    placeholderStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color:
                            Theme.of(context).extension<CustomColors>()!.label!.withOpacity(0.6)),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).extension<CustomColors>()!.label),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      _showDateTimeDialog(
                        CupertinoDatePicker(
                          initialDateTime: DateTime.now(),
                          mode: CupertinoDatePickerMode.dateAndTime,
                          use24hFormat: true,
                          showDayOfWeek: false,
                          onDateTimeChanged: (DateTime newDate) {
                            setState(() {
                              showedDateTime = newDate;
                            });
                            setDateTime(newDate);
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemFill,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${showedDateTime.day}.${showedDateTime.month}.${showedDateTime.year} ${showedDateTime.hour}:${showedDateTime.minute}',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context)
                                    .extension<CustomColors>()!
                                    .label!
                                    .withOpacity(0.6)),
                          ),
                          const Spacer(),
                          ImageHelper.svgImage(SvgNames.calendar, width: 20, height: 20)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      nameFieldController.text.isNotEmpty && countFieldController.text.isNotEmpty
                          ? ImageHelper.svgImage(SvgNames.radioInline)
                          : ImageHelper.svgImage(SvgNames.radioOutline),
                      const SizedBox(width: 8),
                      Text('Complete', style: Theme.of(context).textTheme.bodyLarge)
                    ],
                  ),
                  const Spacer(),
                  AppButton(
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    width: 136,
                    callback: nameFieldController.text.isNotEmpty
                        ? countFieldController.text.isNotEmpty
                            ? () => save(tab)
                            : null
                        : null,
                    name: 'Save',
                    textColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            );
          });
        },
      );
      //edit
    } else if (mode == Mode.edit) {
      final transactions = dataBase.transactions;
      final goals = dataBase.goals;
      showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: ImageHelper.svgImage(SvgNames.cupSheet)),
                const SizedBox(height: 14),
                Text(tab == Tab.savings ? 'Select savings' : 'Select goals',
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 48),
                SizedBox(
                  height: 400,
                  child: ListView(
                    children: [
                      if (tab == Tab.savings)
                        ...transactions.map(
                          (e) => EditTransactionContainer(
                            transaction: e,
                            currency: currencyController.value.selectedCurrency!,
                            index: transactions.indexOf(e),
                            onTap: () => openEditMenu(
                                transaction: e,
                                tab: tab,
                                goal: Goal(
                                  name: '',
                                  amount: 0,
                                  amountAccumulated: 0,
                                  dateTimeCreate: DateTime.now(),
                                  dateTimeExpire: DateTime.now(),
                                )),
                          ),
                        ),
                      if (tab == Tab.goals)
                        ...goals.map((e) => EditGoalContainer(
                            goal: e,
                            currency: currencyController.value.selectedCurrency!,
                            index: goals.indexOf(e),
                            onTap: () => openEditMenu(
                                  transaction:
                                      Transaction(name: '', amount: 0, dateTime: DateTime.now()),
                                  tab: tab,
                                  goal: e,
                                )))
                    ],
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          );
        },
      ); //delete
    } else {
      final transactions = dataBase.transactions;
      final goals = dataBase.goals;
      showCupertinoModalPopup(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageHelper.svgImage(SvgNames.cupSheet),
                  const SizedBox(height: 14),
                  Text(tab == Tab.savings ? 'Delete saving' : 'Delete goal'),
                  listViewDismissible(
                      tab: tab,
                      items: tab == Tab.savings ? transactions : goals,
                      onDismiss: (value) {
                        if (tab == Tab.savings) {
                          walletController.deleteTransaction(transaction: value);
                        } else {
                          walletController.deleteGoal(name: value.name);
                        }
                      }),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget listViewDismissible(
      {required List<dynamic> items, required Function(dynamic e) onDismiss, required Tab tab}) {
    return ListView(shrinkWrap: true, children: [
      ...items.map(
        (e) => Dismissible(
          key: Key(e.name),
          background: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ),
          onDismissed: (direction) async {
            onDismiss(e);
          },
          child: tab == Tab.savings
              ? TransactionContainer(
                  transaction: e,
                  currency: currencyController.value.selectedCurrency!,
                  index: items.indexOf(e),
                )
              : GoalContainer(
                  goal: e,
                  index: items.indexOf(e),
                  walletController: walletController,
                  currency: currencyController.value.selectedCurrency!,
                ),
        ),
      )
    ]);
  }

  void _showDateTimeDialog(Widget child) {
    showCupertinoModalPopup<void>(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void init() {
    walletController = WalletController();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    countFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ValueListenableBuilder(
        valueListenable: walletController,
        builder: (BuildContext context, WalletControllerState state, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).extension<CustomColors>()!.background,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    child: CupertinoSlidingSegmentedControl<Tab>(
                      backgroundColor: Theme.of(context).extension<CustomColors>()!.walletBg!,
                      thumbColor: Theme.of(context).colorScheme.onPrimary,
                      groupValue: _selectedSegment,
                      padding: const EdgeInsets.all(2),
                      onValueChanged: (Tab? value) {
                        if (value != null) {
                          setState(() {
                            _selectedSegment = value;
                          });
                        }
                      },
                      children: <Tab, Widget>{
                        Tab.savings: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Balance',
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                  color: _selectedSegment == Tab.savings
                                      ? Theme.of(context).colorScheme.onBackground
                                      : Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                        Tab.goals: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Goals',
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                  color: _selectedSegment == Tab.goals
                                      ? Theme.of(context).colorScheme.onBackground
                                      : Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ExpandableTheme(
                    data: const ExpandableThemeData(
                        iconColor: Colors.red, animationDuration: Duration(milliseconds: 500)),
                    child: ExpandableNotifier(
                      controller: controller,
                      child: ExpandablePanel(
                        theme: const ExpandableThemeData(iconColor: Colors.blue),
                        collapsed: Container(
                          height: 114,
                          width: double.infinity,
                          padding: const EdgeInsets.only(bottom: 9, top: 15),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            image: DecorationImage(
                              image: ImageHelper.getImage(ImageNames.walletBg).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _selectedSegment == Tab.savings ? 'Total balance' : 'You have',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(height: 3),
                              FittedBox(
                                child: Text(
                                    _selectedSegment == Tab.savings
                                        ? '${currencyController.value.selectedCurrency?.sign ?? '\$'}${state.balance.toStringAsFixed(2)}'
                                        : '${state.goals.length} Goals',
                                    style: Theme.of(context).textTheme.displayLarge),
                              ),
                              const Spacer(),
                              ImageHelper.svgImage(SvgNames.chevronBottom),
                            ],
                          ),
                        ),
                        expanded: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).extension<CustomColors>()!.walletBg,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 114,
                                width: double.infinity,
                                padding: const EdgeInsets.only(bottom: 9, top: 15),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  image: DecorationImage(
                                    image: ImageHelper.getImage(ImageNames.walletBg).image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        _selectedSegment == Tab.savings
                                            ? 'Total balance'
                                            : 'You have',
                                        style: Theme.of(context).textTheme.labelMedium),
                                    const SizedBox(height: 3),
                                    FittedBox(
                                      child: Text(
                                          _selectedSegment == Tab.savings
                                              ? '${currencyController.value.selectedCurrency?.sign ?? '\$'}${state.balance.toStringAsFixed(2)}'
                                              : '${state.goals.length} Goals',
                                          style: Theme.of(context).textTheme.displayLarge),
                                    ),
                                    const Spacer(),
                                    ImageHelper.svgImage(SvgNames.chevronUpper),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () =>
                                          openWalletMenu(mode: Mode.add, tab: _selectedSegment),
                                      child: Column(
                                        children: [
                                          ImageHelper.svgImage(SvgNames.add),
                                          const SizedBox(height: 5),
                                          Text(
                                            _selectedSegment == Tab.savings
                                                ? 'Add saving'
                                                : 'Add goals',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: Theme.of(context).colorScheme.onPrimary),
                                          )
                                        ],
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        children: [
                                          ImageHelper.svgImage(SvgNames.delete),
                                          const SizedBox(height: 5),
                                          Text(
                                            _selectedSegment == Tab.savings
                                                ? 'Delete saving'
                                                : 'Delete goals',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: Theme.of(context).colorScheme.onPrimary),
                                          )
                                        ],
                                      ),
                                      onPressed: () =>
                                          openWalletMenu(mode: Mode.delete, tab: _selectedSegment),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        children: [
                                          ImageHelper.svgImage(SvgNames.edit),
                                          const SizedBox(height: 5),
                                          Text(
                                            _selectedSegment == Tab.savings
                                                ? 'Edit saving'
                                                : 'Edit goals',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall!
                                                .copyWith(
                                                    color: Theme.of(context).colorScheme.onPrimary),
                                          )
                                        ],
                                      ),
                                      onPressed: () =>
                                          openWalletMenu(mode: Mode.edit, tab: _selectedSegment),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 23),
                            ],
                          ),
                        ),
                        builder: (_, collapsed, expanded) {
                          return GestureDetector(
                            onTap: () => controller.toggle(),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(crossFadePoint: 0),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InfoTablet(
                    transactions: state.transactions,
                    goals: state.goals,
                    currency: currencyController.value.selectedCurrency ??
                        const CurrencyUint(
                            name: 'USD', symbol: 'USD', iconUrl: '', sign: '\$', uuid: '000'),
                    selectSegment: _selectedSegment,
                    walletController: walletController,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoTablet extends StatelessWidget {
  const InfoTablet({
    super.key,
    required this.transactions,
    required this.goals,
    required this.selectSegment,
    required this.walletController,
    required this.currency,
  });

  final List<Transaction> transactions;
  final List<Goal> goals;
  final Tab selectSegment;
  final WalletController walletController;
  final CurrencyUint currency;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ImageHelper.svgImage(SvgNames.cupSheet)),
            const SizedBox(height: 14),
            Text(selectSegment == Tab.savings ? 'Savings' : 'Total goals',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  selectSegment == Tab.savings
                      ? transactions.isEmpty
                          ? const Center(child: Text('Add some savings'))
                          : const SizedBox()
                      : goals.isEmpty
                          ? const Center(child: Text('Add some goals'))
                          : const SizedBox(),
                  ...selectSegment == Tab.savings
                      ? transactions.map((e) => TransactionContainer(
                            currency: currency,
                            transaction: e,
                            index: transactions.indexOf(e),
                          ))
                      : goals.map((e) => GoalContainer(
                            goal: e,
                            currency: currency,
                            index: goals.indexOf(e),
                            walletController: walletController,
                          )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditTransactionContainer extends StatelessWidget {
  EditTransactionContainer({
    super.key,
    required this.transaction,
    required this.index,
    required this.onTap,
    required this.currency,
  });

  final Transaction transaction;
  final VoidCallback onTap;
  final CurrencyUint currency;
  int index;

  final colors = const [
    Color(0xFFF0BEEC),
    Color(0xFFDDFBCF),
    Color(0xFFD9CFFB),
    Color(0xFFFBCFCF),
    Color(0xFF4B26F0),
  ];

  @override
  Widget build(BuildContext context) {
    index = index % 4;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => onTap.call(),
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF4F4F4),
          ),
          child: ListTile(
            leading: Container(
              width: 38,
              height: 38,
              decoration:
                  BoxDecoration(color: colors[index], borderRadius: BorderRadius.circular(50)),
              child: const Center(
                  child: Text(
                '💸',
                style: TextStyle(fontSize: 15),
              )),
            ),
            title: Text(
              transaction.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text(
              DateParser.parseDate(dateTime: transaction.dateTime),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
            ),
            trailing: Text(
              '${currency.sign ?? '\$'}${transaction.amount.toString()}\$',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionContainer extends StatelessWidget {
  TransactionContainer({
    super.key,
    required this.transaction,
    required this.index,
    required this.currency,
  });

  final Transaction transaction;
  int index;
  final CurrencyUint currency;
  final colors = const [
    Color(0xFFF0BEEC),
    Color(0xFFDDFBCF),
    Color(0xFFD9CFFB),
    Color(0xFFFBCFCF),
    Color(0xFF4B26F0),
  ];

  @override
  Widget build(BuildContext context) {
    index = index % 4;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF4F4F4),
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: colors[index], borderRadius: BorderRadius.circular(50)),
          child: const Center(
              child: Text(
            '💸',
            style: TextStyle(fontSize: 15),
          )),
        ),
        title: Text(
          transaction.name,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        subtitle: Text(
          DateParser.parseDate(dateTime: transaction.dateTime),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
        ),
        trailing: Text(
          '${transaction.amount.toString()}${currency.sign}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}

class EditGoalContainer extends StatelessWidget {
  EditGoalContainer({
    super.key,
    required this.goal,
    required this.index,
    required this.onTap,
    required this.currency,
  });

  final Goal goal;
  final CurrencyUint currency;
  final VoidCallback onTap;
  int index;

  @override
  Widget build(BuildContext context) {
    index = index % 4;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => onTap.call(),
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF4F4F4),
          ),
          child: ListTile(
            // leading: ImageHelper.getImage('saving_$index'),
            leading: Container(
              width: 38,
              height: 38,
              decoration:
                  BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(50)),
              child: Center(
                  child: Text(
                '💸',
                style: TextStyle(fontSize: 15),
              )),
            ),
            title: Text(
              goal.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text(
              DateParser.parseDate(dateTime: goal.dateTimeExpire),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5)),
            ),
            trailing: Text(
              '${currency.sign}${goal.amount.toString()}\$',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class GoalContainer extends StatelessWidget {
  GoalContainer({
    super.key,
    required this.goal,
    required this.index,
    required this.walletController,
    required this.currency,
  });

  final Goal goal;
  final ExpandableController controller = ExpandableController();
  final CurrencyUint currency;
  int index;
  final amountController = TextEditingController();
  final WalletController walletController;

  List<Color> colors = const [
    Color(0xFFF0BEEC),
    Color(0xFFD9CFFB),
    Color(0xFFFBCFCF),
    Color(0xFFDDFBCF),
    Color(0xFF4B26F0),
  ];

  void increaseGoal({required BuildContext context}) {
    showCupertinoModalPopup(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Container(
              width: double.infinity,
              // height: MediaQuery.of(context).size.height * 0.3,
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
                  const SizedBox(height: 15),
                  Text('Add money to ${goal.name}', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    controller: amountController,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemFill,
                        borderRadius: BorderRadius.circular(10)),
                    placeholder: 'Enter the amount',
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
                      name: 'Save',
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      width: double.infinity,
                      callback: () {
                        if (walletController.addMoneyToGoal(
                            goal: goal,
                            amount: double.parse(amountController.text),
                            context: context)) {
                          Navigator.of(context).pop();
                        }
                      }),
                  const SizedBox(height: 15)
                ],
              ),
            );
          },
        );
      },
    );
  }

  void decreaseGoal({required BuildContext context}) {
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
                  const SizedBox(height: 15),
                  Text('Withdraw money from ${goal.name}',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    controller: amountController,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemFill,
                        borderRadius: BorderRadius.circular(10)),
                    placeholder: 'Enter the amount',
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
                      name: 'Save',
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      width: double.infinity,
                      callback: () {
                        if (walletController.removeMoneyFromGoal(
                            goal: goal,
                            amount: double.parse(amountController.text),
                            context: context)) {
                          Navigator.of(context).pop();
                        }
                      }),
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
    index = index % 4;
    return ExpandableTheme(
      data: const ExpandableThemeData(
          iconColor: Colors.red, animationDuration: Duration(milliseconds: 500)),
      child: ExpandableNotifier(
        controller: controller,
        child: ExpandablePanel(
          theme: const ExpandableThemeData(iconColor: Colors.blue),
          collapsed: Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF4F4F4),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          color: colors[index], borderRadius: BorderRadius.circular(50)),
                      child: Center(
                          child: Text(
                        '${index + 1}',
                        style: GoogleFonts.syne(
                            fontSize: 15, color: Theme.of(context).colorScheme.onBackground),
                      )),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).colorScheme.onBackground),
                        ),
                        const SizedBox(height: 5),
                        StepDivider(
                          height: 5,
                          fillPercentage: (goal.amountAccumulated * 100 / goal.amount).round(),
                          width: MediaQuery.of(context).size.width / 3,
                          color: Theme.of(context).extension<CustomColors>()!.goalStepper!,
                          filledColor:
                              Theme.of(context).extension<CustomColors>()!.goalStepperFilled!,
                        )
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      ImageHelper.svgImage(SvgNames.calendar,
                          width: 9, height: 9, color: Colors.black),
                      const SizedBox(width: 5),
                      Text(
                        DateParser.parseDate(dateTime: goal.dateTimeExpire),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          expanded: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF4F4F4),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          color: colors[index], borderRadius: BorderRadius.circular(50)),
                      child: Center(
                          child: Text(
                        '${index + 1}',
                        style: GoogleFonts.syne(
                            fontSize: 15, color: Theme.of(context).colorScheme.onBackground),
                      )),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Theme.of(context).colorScheme.onBackground),
                        ),
                        const SizedBox(height: 5),
                        StepDivider(
                          height: 5,
                          fillPercentage: (goal.amountAccumulated * 100 / goal.amount).round(),
                          width: MediaQuery.of(context).size.width / 3,
                          color: Theme.of(context).extension<CustomColors>()!.goalStepper!,
                          filledColor:
                              Theme.of(context).extension<CustomColors>()!.goalStepperFilled!,
                        )
                      ],
                    ),
                    const Spacer(),
                    ImageHelper.svgImage(SvgNames.chevronBottom, color: Colors.black)
                  ],
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    Text('Creating data: ', style: Theme.of(context).textTheme.bodyMedium),
                    ImageHelper.svgImage(SvgNames.calendar,
                        width: 9, height: 9, color: Colors.black),
                    Text(DateParser.parseDate(dateTime: goal.dateTimeCreate),
                        style: Theme.of(context).textTheme.displaySmall)
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text('Ending data: ', style: Theme.of(context).textTheme.bodyMedium),
                    ImageHelper.svgImage(SvgNames.calendar,
                        width: 9, height: 9, color: Colors.black),
                    Text(DateParser.parseDate(dateTime: goal.dateTimeExpire),
                        style: Theme.of(context).textTheme.displaySmall)
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text('Money accumulated: ', style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                        '${goal.amountAccumulated.round()}${currency.sign}/${goal.amount.round()}${currency.sign}',
                        style: Theme.of(context).textTheme.displaySmall)
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton(
                      name: 'Add money',
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      callback: () => increaseGoal(context: context),
                    ),
                    AppButton(
                      name: 'Withdraw',
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      callback: () => decreaseGoal(context: context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          builder: (_, collapsed, expanded) {
            return GestureDetector(
              onTap: () => controller.toggle(),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(crossFadePoint: 0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
