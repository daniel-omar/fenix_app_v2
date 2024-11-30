import 'package:flutter/material.dart';

class CustomElevatedIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? text;
  final Color? buttonColor;
  final IconData? icon;

  const CustomElevatedIconButton(
      {super.key,
      this.onPressed,
      this.text,
      required this.icon,
      this.buttonColor});

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10);

    return ElevatedButton.icon(
      icon: Icon(icon),
      style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: radius,
                  bottomRight: radius,
                  topLeft: radius,
                  topRight: radius))),
      onPressed: onPressed,
      label: Text(text!),
    );
  }
}
