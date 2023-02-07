import 'package:flutter/foundation.dart';
import 'package:informers/inform_notifier.dart';

/// Altered version of Flutter's [ValueNotifier] with extended list capabilities.
class MaxLengthListInformer<T> extends InformNotifier
    implements ValueListenable<List<T>> {
  MaxLengthListInformer(
    this._value, {
    bool forceUpdate = false,
    int maxLength = 50,
  })  : _forceUpdate = forceUpdate,
        _maxLength = maxLength;

  /// Current list of the informer.
  List<T> _value;

  /// Getter of the current list of the informer.
  @override
  List<T> get value => _value;

  /// Indicates whether the informer should always update the value and [notifyListeners] when calling the [update] and [updateCurrent] methods.
  ///
  /// Even though the value might be the same.
  final bool _forceUpdate;

  /// Maximum length of the list.
  final int _maxLength;

  /// Setter of the current list of the informer.
  void update(
    List<T> value, {
    bool doNotifyListeners = true,
  }) {
    if (_forceUpdate || _value != value) {
      _value = value;
      _checkAndRemoveLowerDifference();
      if (doNotifyListeners) {
        notifyListeners();
      }
    }
  }

  /// Provides current list and updates the list of the informer with received list.
  void updateCurrent(
    List<T> Function(List<T> current) current, {
    bool doNotifyListeners = true,
  }) {
    final newValue = current(List.from(_value));
    if (_forceUpdate || listEquals(_value, newValue)) {
      _value = newValue;
      _checkAndRemoveLowerDifference();
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
    _checkAndRemoveLowerDifference();
    if (doNotifyListeners) {
      notifyListeners();
    }
  }

  /// Adds all values to the list.
  void addAll(
    Iterable<T> values, {
    bool doNotifyListeners = true,
  }) {
    _value.addAll(values);
    _checkAndRemoveLowerDifference();
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
    final removed = _value.removeLast();
    if (doNotifyListeners) {
      notifyListeners();
    }
    return removed;
  }

  /// Updates the first value that meets the criteria with given [update].
  T? updateFirstWhereOrNull(
    bool Function(T value) test,
    T Function(T value) update, {
    bool doNotifyListeners = true,
  }) {
    int? localIndex;
    T? toBeUpdated;
    for (int index = 0; index < _value.length; index++) {
      final value = _value[index];
      if (test(value)) {
        localIndex = index;
        toBeUpdated = value;
      }
    }
    if (toBeUpdated != null) {
      final updated = update(toBeUpdated);
      _value[localIndex!] = updated;
      if (doNotifyListeners) {
        notifyListeners();
      }
      return updated;
    }
    return null;
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

  /// Removes any items that exceed [_maxLength].
  void _checkAndRemoveLowerDifference() {
    if (_value.length > _maxLength) {
      final difference = _maxLength - _value.length;
      for (int x = 0; x < difference; x++) {
        _value.removeAt(0);
      }
    }
  }

  @override
  String toString() {
    return 'MaxLengthListInformer{_value: $_value, _forceUpdate: $_forceUpdate, _maxLength: $_maxLength}';
  }
}
