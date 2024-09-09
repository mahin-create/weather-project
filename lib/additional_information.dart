import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInformation({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Icon(
            icon,
            size: 40,
        ),
        const SizedBox(height: 10),
        Text(label),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
      ],
    );
  }
}
