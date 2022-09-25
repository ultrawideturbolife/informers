import 'package:flutter/foundation.dart';
import 'package:informers/inform_notifier.dart';

/// Altered version of Flutter's [ValueNotifier] with extended capabilities.
class Informer<T> extends InformNotifier implements ValueListenable<T> {
  Informer(
    this._value, {
    bool forceUpdate = true,
  }) : _forceUpdate = forceUpdate;

  /// Current value of the informer.
  T _value;


  /// Getter of the current value of the informer.
  @override
  T get value => _value;

  /// Indicates whether the informer should always update the value and [notifyListeners] when calling the [update] and [updateCurrent] methods.
  ///
  /// Even though the value might be the same.
  final bool _forceUpdate;

  /// Setter of the current value of the informer.
  void update(T value) {
    if (_forceUpdate || _value != value) {
      _value = value;
      notifyListeners();
    }
  }

  /// Provides current value and updates it with received value.
  void updateCurrent(T Function(T value) current) {
    final newValue = current(_value);
    if (_forceUpdate || _value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  @override
  String toString() => 'Notifier{_value: $_value}';
}
