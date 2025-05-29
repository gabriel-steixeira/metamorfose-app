import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';

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
    return Container(
      width: double.infinity, //358
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: strokeColor,
          ),
          borderRadius: BorderRadius.circular(12),
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
                fontSize: 15,
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
    );
  }
} 