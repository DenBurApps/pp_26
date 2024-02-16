import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    this.black,
    this.background,
    this.walletBg,
    this.label,
    this.goalStepper,
    this.goalStepperFilled,
  });

  final Color? black;
  final Color? background;
  final Color? walletBg;
  final Color? label;
  final Color? goalStepper;
  final Color? goalStepperFilled;

  @override
  CustomColors copyWith({
    Color? black,
    Color? background,
    Color? walletBg,
    Color? label,
    Color? goalStepper,
    Color? goalStepperFilled,
  }) {
    return CustomColors(
      black: black ?? this.black,
      background: background ?? this.background,
      walletBg: walletBg ?? this.walletBg,
      label: label ?? this.label,
      goalStepper: goalStepper ?? this.goalStepper,
      goalStepperFilled: goalStepperFilled ?? this.goalStepperFilled,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      black: Color.lerp(black, other.black, t)!,
      background: Color.lerp(background, other.background, t)!,
      walletBg: Color.lerp(walletBg, other.walletBg, t)!,
      label: Color.lerp(label, other.label, t)!,
      goalStepper: Color.lerp(goalStepper, other.goalStepper, t)!,
      goalStepperFilled: Color.lerp(goalStepperFilled, other.goalStepperFilled, t)!,
    );
  }

  static const light = CustomColors(
    black: Color(0xFF1E1E1E),
    background: Color(0xFF141316),
    walletBg: Color(0xFF262329),
    label: Color(0xFF3C3C43),
    goalStepper: Color(0xFFDCDCDC),
    goalStepperFilled: Color(0xFFA2D0A9),
  );
}
