import 'package:flutter/foundation.dart';

/// Altered version of Flutter's [ValueNotifier] with extended map capabilities.
class MapNotifier<E, T> extends ChangeNotifier
    implements ValueListenable<Map<E, T>> {
  MapNotifier(this._value);

  /// Current map of the informer.
  Map<E, T> _value;

  @override

  /// Getter of the current map of the informer.
  Map<E, T> get value => _value;

  /// Setter of the current map of the informer.
  void update(Map<E, T> value) {
    _value = value;
    notifyListeners();
  }

  /// Provides current map and updates the map of the informer with received map.
  void updateCurrent(Map<E, T> Function(Map<E, T> value) current) {
    _value = current(_value);
    notifyListeners();
  }

  /// Assigns [value] to [key].
  void add(E key, T value) {
    _value[key] = value;
    notifyListeners();
  }

  /// Performs a [Map.putIfAbsent] and returns its return value.
  T putIfAbsent(E key, T value) {
    final _returnValue = _value.putIfAbsent(key, () => value);
    notifyListeners();
    return _returnValue;
  }

  @override
  String toString() => 'MapNotifier{_value: $_value}';
}
