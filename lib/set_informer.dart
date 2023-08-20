import 'package:flutter/foundation.dart';
import 'package:informers/inform_notifier.dart';

/// Altered version of Flutter's [ValueNotifier] with extended list capabilities.
class SetInformer<T> extends InformNotifier implements ValueListenable<Set<T>> {
  SetInformer(
    this._value, {
    bool forceUpdate = false,
  }) : _forceUpdate = forceUpdate;

  /// Current list of the informer.
  Set<T> _value;

  /// Getter of the current list of the informer.
  @override
  Set<T> get value => _value;

  /// Indicates whether the informer should always update the value and [notifyListeners] when calling the [update] and [updateCurrent] methods.
  ///
  /// Even though the value might be the same.
  final bool _forceUpdate;

  /// Setter of the current list of the informer.
  void update(
    Set<T> value, {
    bool doNotifyListeners = true,
  }) {
    if (_forceUpdate || !setEquals(_value, value)) {
      _value = value;
      if (doNotifyListeners) {
        notifyListeners();
      }
    }
  }

  /// Provides current list and updates the list of the informer with received list.
  void updateCurrent(
    Set<T> Function(Set<T> current) current, {
    bool doNotifyListeners = true,
  }) {
    final newValue = current(Set.from(_value));
    if (_forceUpdate || !setEquals(_value, newValue)) {
      _value = newValue;
      if (doNotifyListeners) {
        notifyListeners();
      }
    }
  }

  /// Adds a value to the list.
  void add(
    T value, {
    bool doNotifyListeners = true,
  }) {
    _value.add(value);
    if (doNotifyListeners) {
      notifyListeners();
    }
  }

  /// Removes a value from the list.
  bool remove(
    T value, {
    bool doNotifyListeners = true,
  }) {
    final result = _value.remove(value);
    if (doNotifyListeners) {
      notifyListeners();
    }
    return result;
  }

  /// Removes the last value from the list.
  T removeLast({
    bool doNotifyListeners = true,
  }) {
    final last = _value.last;
    _value.remove(last);
    if (doNotifyListeners) {
      notifyListeners();
    }
    return last;
  }

  /// Whether the [_value] is empty.
  bool get isEmpty => _value.isEmpty;

  /// Whether the [_value] is not empty.
  bool get isNotEmpty => _value.isNotEmpty;

  /// Whether the [_value] contains [value].
  bool contains(T value) => _value.contains(value);

  /// Clears [_value] of any values.
  void clear({
    bool doNotifyListeners = true,
  }) {
    _value.clear();
    if (doNotifyListeners) {
      notifyListeners();
    }
  }

  @override
  String toString() {
    return 'SetInformer{_value: $_value, _forceUpdate: $_forceUpdate}';
  }
}
