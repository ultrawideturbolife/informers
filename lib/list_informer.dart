import 'package:flutter/foundation.dart';
import 'package:informers/inform_notifier.dart';

/// Altered version of Flutter's [ValueNotifier] with extended list capabilities.
class ListInformer<T> extends InformNotifier implements ValueListenable<List<T>> {
  ListInformer(
    this._value, {
    bool forceUpdate = true,
  }) : _forceUpdate = forceUpdate;

  /// Current list of the informer.
  List<T> _value;


  /// Getter of the current list of the informer.
  @override
  List<T> get value => _value;

  /// Indicates whether the informer should always update the value and [notifyListeners] when calling the [update] and [updateCurrent] methods.
  ///
  /// Even though the value might be the same.
  final bool _forceUpdate;

  /// Setter of the current list of the informer.
  void update(List<T> value) {
    if (_forceUpdate || _value != value) {
      _value = value;
      notifyListeners();
    }
  }

  /// Provides current list and updates the list of the informer with received list.
  void updateCurrent(List<T> Function(List<T> current) current) {
    final newValue = current(_value);
    if (_forceUpdate || _value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  /// Adds a value to the list.
  void add(T value) {
    _value.add(value);
    notifyListeners();
  }

  /// Removes a value from the list.
  bool remove(T value) {
    final _result = _value.remove(value);
    notifyListeners();
    return _result;
  }

  /// Removes the last value from the list.
  T removeLast() {
    final _removed = _value.removeLast();
    notifyListeners();
    return _removed;
  }

  /// Updates the first value that meets the criteria with given [update].
  T? updateFirstWhereOrNull(
    bool Function(T value) test,
    T Function(T value) update,
  ) {
    final toBeUpdated = () {
      for (final element in _value) {
        if (test(element)) return element;
      }
      return null;
    }();
    if (toBeUpdated != null) {
      final updated = update(toBeUpdated);
      _value[_value.indexOf(toBeUpdated)] = updated;
      return updated;
    }
    return null;
  }

  /// Whether the [_value] is empty.
  bool get isEmpty => _value.isEmpty;

  /// Whether the [_value] is not empty.
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  String toString() => 'ListNotifier{_value: $_value}';
}
