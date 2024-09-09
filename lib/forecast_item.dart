import 'package:flutter/material.dart';

class ForecastItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ForecastItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
               Icon(icon,size: 30),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(
                fontSize: 14,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
