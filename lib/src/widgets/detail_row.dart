import 'package:flutter/material.dart';

class Detail{
  const Detail({required this.label,
    required this.text,});
  final String label;
  final String text; 
}

class DetailRow extends StatelessWidget {
  const DetailRow({
    Key? key,
    required this.detail
  }) : super(key: key);
  final Detail detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(detail.label),
        //const SizedBox(width: 16),
        Text(detail.text),
      ],
    );
  }
}
