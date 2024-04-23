import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const DefaultButton(
      {super.key, required this.text, required this.onPressed, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(color),
          textStyle: MaterialStatePropertyAll(TextStyle(color: textColor)),
        ),
        child: Text(text,style: TextStyle(color: textColor),));
  }
}
