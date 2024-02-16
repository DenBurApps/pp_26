import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.name,
    this.callback,
    this.backgroundColor,
    required this.textColor,
    this.textStyle,
    this.width,
    this.borderRadius,
    this.margin,
  });

  final String name;
  final VoidCallback? callback;
  final Color? backgroundColor;
  final Color textColor;
  final TextStyle? textStyle;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 43,
      margin: margin,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        disabledColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        color: backgroundColor ?? Theme.of(context).extension<CustomColors>()!.black,
        onPressed: callback,
        borderRadius: borderRadius ?? BorderRadius.circular(15),
        child: Text(
          name,
          style: textStyle ?? Theme.of(context).textTheme.labelMedium!.copyWith(color: textColor),
        ),
      ),
    );
  }
}
