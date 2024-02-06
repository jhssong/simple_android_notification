import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const InfoBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Text(
        '$label: $value',
        overflow: TextOverflow.ellipsis,
        maxLines: 10,
      ),
    );
  }
}
