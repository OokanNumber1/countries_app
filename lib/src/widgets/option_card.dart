import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    required this.icon,
    required this.label,
    required this.onClick,
    super.key,
  });
  final String label;
  final Icon icon;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
