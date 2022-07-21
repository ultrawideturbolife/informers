import 'package:flutter/foundation.dart';

/// Altered version of Flutter's [ValueNotifier] with extended list capabilities.
class ListInformer<T> extends ChangeNotifier
    implements ValueListenable<List<T>> {
  ListInformer(this._value);

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

  @override
  String toString() => 'ListNotifier{_value: $_value}';
}
