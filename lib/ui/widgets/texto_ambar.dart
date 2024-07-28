import 'package:flutter/material.dart';

class TextoAmbar extends StatelessWidget {
  final String texto;

  const TextoAmbar({
    super.key,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(color: Colors.amber),
    );
  }
}
