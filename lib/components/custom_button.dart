import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color shadowColor;
  final Color strokeColor;
  final Widget? child;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.shadowColor,
    required this.strokeColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Valores responsivos baseados no breakpoint
    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 15.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 13.0),
        Condition.largerThan(name: TABLET, value: 17.0),
      ],
    ).value;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: strokeColor,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          shadows: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 0,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (child != null)
              Center(child: child)
            else
              Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontFamily: 'DinNext',
                  fontWeight: FontWeight.w700,
                  height: 1.27,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 15,
                      color: MetamorfoseColors.shadowText,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}