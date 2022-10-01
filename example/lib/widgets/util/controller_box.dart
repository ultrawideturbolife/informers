import 'package:flutter/material.dart';

class ControllerBox {
  final Map<Symbol, TextEditingController> _controllers = {};

  TextEditingController get(Symbol symbol) =>
      _controllers.putIfAbsent(symbol, () => TextEditingController());

  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
  }
}
