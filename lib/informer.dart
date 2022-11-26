import 'package:flutter/foundation.dart';
import 'package:informers/inform_notifier.dart';

/// Altered version of Flutter's [ValueNotifier] with extended capabilities.
class Informer<T> extends InformNotifier implements ValueListenable<T> {
  Informer(
    this._value, {
    bool forceUpdate = false,
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
  void update(
    T value, {
    bool doNotifyListeners = true,
  }) {
    if (_forceUpdate || _value != value) {
      _value = value;
      if (doNotifyListeners) {
        notifyListeners();
      }
    }
  }

  /// Provides current value and updates it with received value.
  void updateCurrent(
    T Function(T value) current, {
    bool doNotifyListeners = true,
  }) {
    final newValue = current(_value);
    if (_forceUpdate || _value != newValue) {
      _value = newValue;
      if (doNotifyListeners) {
        notifyListeners();
      }
    }
  }

  @override
  String toString() {
    return 'Informer{_value: $_value, _forceUpdate: $_forceUpdate}';
  }
}
