import 'package:flutter/foundation.dart';

/// Altered version of Flutter's [ValueNotifier] with extended list capabilities.
class ListNotifier<T> extends ChangeNotifier
    implements ValueListenable<List<T>> {
  ListNotifier(this._value);

  /// Current list of the informer.
  List<T> _value;

  @override

  /// Getter of the current list of the informer.
  List<T> get value => _value;

  /// Setter of the current list of the informer.
  void update(List<T> value) {
    _value = value;
    notifyListeners();
  }

  /// Provides current list and updates the list of the informer with received list.
  void updateCurrent(List<T> Function(List<T> value) current) {
    _value = current(_value);
    notifyListeners();
  }

  /// Adds a value to the list.
  void add(T value) {
    _value = _value..add(value);
    notifyListeners();
  }

  /// Removes a value from the list.
  void remove(T value) {
    _value = _value..remove(value);
    notifyListeners();
  }

  /// Removes the last value from the list.
  void removeLast() {
    _value = _value..removeLast();
    notifyListeners();
  }

  /// Updates the first value that meets the criteria with given [update].
  void updateFirstWhere(
      bool Function(T value) test, T Function(T value) update) {
    final toBeUpdated = _value.firstWhere(test);
    final updated = update(toBeUpdated);
    _value = _value..[_value.indexOf(toBeUpdated)] = updated;
  }

  @override
  String toString() => 'ListNotifier{_value: $_value}';
}
