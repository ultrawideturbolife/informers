This is a simple package that copies and alters the behaviour of Flutter’s `ValueNotifier`. The main difference is that the notifiers in this package allow for easier updating when having `iterables` like `maps` and `lists` as your value.

The idea for future development evolves around improving all infomrers to mimic default iterable’s behaviours and at the same time updating the listeners as efficient as possible. Feel free to make requests or a PR if you have any ideas and/or want to see any specific methods/classes added.

<aside>
❗ This project has an extensive sample project along with many unit tests that demonstrate the use of this package very nicely.

</aside>

# 🏛 General

Each type of informer (`Informer`, `ListInformer` and `MapInformer`) has access to the three variables and the one rebuild method listed below.

- `_value` / `value` → The current value of the informer.
- `_forceUpdate` → Whether to always rebuild.

    ```dart
    /// Indicates whether the informer should always update the value and [notifyListeners] when calling the [update] and [updateCurrent] methods.
    ///
    /// Even though the value might be the same.
    final bool _forceUpdate;
    ```

- `rebuild()` ⇒ Exposed `notifyListeners` method to manually trigger a rebuild.

    ```dart
    /// Used to force notify the listeners of this super [ChangeNotifier].
    void rebuild() => notifyListeners();
    ```


# 👾 Informer

![1.jpg](https://app.super.so/_next/image?url=https%3A%2F%2Fsuper-static-assets.s3.amazonaws.com%2F653aa7f7-32fd-4a5c-b3cf-2044da52b531%2Fimages%2F302a3d2e-eb0c-4de7-8d96-65eb8eb6bf31.jpg&w=1920&q=80)


Besides the general methods the main `Informer` class also has access to the following methods.

```dart
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
```

![informer.jpg](https://app.super.so/_next/image?url=https%3A%2F%2Fsuper-static-assets.s3.amazonaws.com%2F653aa7f7-32fd-4a5c-b3cf-2044da52b531%2Fimages%2F525df097-a0c7-4772-9dd7-f3c7ae6443d4.jpg&w=1920&q=80)

# 🦾 ListInformer

![3.jpg](https://app.super.so/_next/image?url=https%3A%2F%2Fsuper-static-assets.s3.amazonaws.com%2F653aa7f7-32fd-4a5c-b3cf-2044da52b531%2Fimages%2F51d6cb40-f317-430d-9935-815f02ef9f1d.jpg&w=1920&q=80)

Besides the general methods the `ListInformer` class also has access to the following methods.

```dart
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
    int? _index;
    T? toBeUpdated;
    for (int index = 0; index < _value.length; index++) {
      final value = _value[index];
      if (test(value)) {
        _index = index;
        toBeUpdated = value;
      }
    }
    if (toBeUpdated != null) {
      final updated = update(toBeUpdated);
      _value[_index!] = updated;
      notifyListeners();
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
  void clear() {
    _value.clear();
    notifyListeners();
  }
```

![listinformer.jpg](https://app.super.so/_next/image?url=https%3A%2F%2Fsuper-static-assets.s3.amazonaws.com%2F653aa7f7-32fd-4a5c-b3cf-2044da52b531%2Fimages%2F9ff207af-cb78-48da-a7d1-cef02fc3945c.jpg&w=1920&q=80)

# 🤖 MapInformer

![2.jpg](https://app.super.so/_next/image?url=https%3A%2F%2Fsuper-static-assets.s3.amazonaws.com%2F653aa7f7-32fd-4a5c-b3cf-2044da52b531%2Fimages%2F67c87b17-2fbe-4cae-bac9-7fad7386ca8d.jpg&w=1920&q=80)

Besides the general methods the `MapInformer` class also has access to the following methods.

```dart
/// Setter of the current map of the informer.
  void update(Map<E, T> value) {
    if (_forceUpdate || _value != value) {
      _value = value;
      notifyListeners();
    }
  }

  /// Provides current map and updates the map of the informer with received map.
  void updateCurrent(Map<E, T> Function(Map<E, T> current) current) {
    final newValue = current(_value);
    if (_forceUpdate || _value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  /// Updates the value for the provided [key] nu calling the [Map.update] method.
  void updateKey(E key, T Function(T value) update, {T Function()? ifAbsent}) {
    _value = _value..update(key, update, ifAbsent: ifAbsent);
    notifyListeners();
  }

  /// Assigns [value] to [key].
  void add(E key, T value) {
    _value[key] = value;
    notifyListeners();
  }

  /// Removes [key] from [_value].
  T? remove(E key) {
    final removed = _value.remove(key);
    notifyListeners();
    return removed;
  }

  /// Performs a [Map.putIfAbsent] and returns its return value.
  T putIfAbsent(E key, T value) {
    final _returnValue = _value.putIfAbsent(key, () => value);
    notifyListeners();
    return _returnValue;
  }

  /// Clears [_value] of any values.
  void clear() {
    _value.clear();
    notifyListeners();
  }
```

![mapinformer.jpg](https://app.super.so/_next/image?url=https%3A%2F%2Fsuper-static-assets.s3.amazonaws.com%2F653aa7f7-32fd-4a5c-b3cf-2044da52b531%2Fimages%2F36990431-6572-4e6c-a83f-75486db03ba1.jpg&w=1920&q=80)
