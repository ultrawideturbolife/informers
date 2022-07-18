import 'package:flutter/foundation.dart';

/// Altered version of Flutter's [ValueNotifier] with extended capabilities.
class Informer<T> extends ChangeNotifier implements ValueListenable<T> {
  Informer(this._value);

  /// Current value of the informer.
  T _value;

  @override

  /// Getter of the current value of the informer.
  T get value => _value;

  /// Setter of the current value of the informer.
  void update(T value) {
    _value = value;
    notifyListeners();
  }

  /// Provides current value and updates it with received value.
  void updateCurrent(T Function(T value) current) {
    _value = current(_value);
    notifyListeners();
  }

  @override
  String toString() => 'Notifier{_value: $_value}';
}
