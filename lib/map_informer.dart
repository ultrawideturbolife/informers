import 'package:flutter/foundation.dart';

import 'inform_notifier.dart';

/// Altered version of Flutter's [ValueNotifier] with extended map capabilities.
class MapInformer<E, T> extends InformNotifier
    implements ValueListenable<Map<E, T>> {
  MapInformer(
    this._value, {
    bool forceUpdate = false,
  }) : _forceUpdate = forceUpdate;

  /// Current map of the informer.
  Map<E, T> _value;

  /// Indicates whether the informer should always update the value and [notifyListeners] when calling the [update] and [updateCurrent] methods.
  ///
  /// Even though the value might be the same.
  final bool _forceUpdate;

  @override

  /// Getter of the current map of the informer.
  Map<E, T> get value => _value;

  /// Setter of the current map of the informer.
  void update(
    Map<E, T> value, {
    bool doNotifyListeners = true,
  }) {
    if (_forceUpdate || !mapEquals(_value, value)) {
      _value = value;
      if (doNotifyListeners) {
        notifyListeners();
      }
    }
  }

  /// Provides current map and updates the map of the informer with received map.
  void updateCurrent(
    Map<E, T> Function(Map<E, T> current) current, {
    bool doNotifyListeners = true,
  }) {
    final newValue = current(Map.from(_value));
    if (_forceUpdate || !mapEquals(_value, newValue)) {
      _value = newValue;
      if (doNotifyListeners) {
        notifyListeners();
      }
    }
  }

  /// Updates the value for the provided [key] nu calling the [Map.update] method.
  void updateKey(
    E key,
    T Function(T value) update, {
    T Function()? ifAbsent,
    bool doNotifyListeners = true,
  }) {
    _value = _value..update(key, update, ifAbsent: ifAbsent);
    if (doNotifyListeners) {
      notifyListeners();
    }
  }

  /// Assigns [value] to [key].
  void add(
    E key,
    T value, {
    bool doNotifyListeners = true,
  }) {
    _value[key] = value;
    if (doNotifyListeners) {
      notifyListeners();
    }
  }

  /// Removes [key] from [_value].
  T? remove(
    E key, {
    bool doNotifyListeners = true,
  }) {
    final removed = _value.remove(key);
    if (doNotifyListeners) {
      notifyListeners();
    }
    return removed;
  }

  /// Performs a [Map.putIfAbsent] and returns its return value.
  T putIfAbsent(
    E key,
    T value, {
    bool doNotifyListeners = true,
  }) {
    final returnValue = _value.putIfAbsent(key, () => value);
    if (doNotifyListeners) {
      notifyListeners();
    }
    return returnValue;
  }

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
    return 'MapInformer{_value: $_value, _forceUpdate: $_forceUpdate}';
  }
}
