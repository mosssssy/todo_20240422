import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({
    super.key,
    required this.buttonText,
    required this.onBlueButtonPressed,
  });
  final String buttonText;
  final VoidCallback onBlueButtonPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onBlueButtonPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            buttonText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
