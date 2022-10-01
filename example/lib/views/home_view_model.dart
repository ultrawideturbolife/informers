import 'dart:math';

import 'package:example/data/constants/const_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:informers/informers.dart';
import 'package:veto/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  final Informer<int> _counter = Informer(0);
  ValueListenable<int> get counterListenable => _counter;

  final ListInformer<String> _listItems = ListInformer([]);
  ValueListenable<List<String>> get listItemsListenable => _listItems;

  final MapInformer<String, String> _mapItems = MapInformer({});
  ValueListenable<Map<String, String>> get mapItemsListenable => _mapItems;

  late final random = Random();

  @override
  Future<void> initialise() async {
    super.initialise();
  }

  @override
  void dispose() {
    _counter.dispose();
    _listItems.dispose();
    super.dispose();
  }

  // -------- Informer ---- Informer ---- Informer -------- \\

  void updateCounter({required int value}) => _counter.update(value);

  void decrementCounter() => _counter.updateCurrent((value) => --value);

  void incrementCounter() => _counter.updateCurrent((value) => ++value);

  // -------- ListInformer ---- ListInformer ---- ListInformer -------- \\

  void updateListItems({required List<String> values}) => _listItems.update(values);

  void decrementListItems() => _listItems.updateCurrent((value) => value..removeLast());

  void incrementListItems() =>
      _listItems.updateCurrent((value) => value..add(_randomGangstaLoremIpsum));

  void addListItem({required String value}) => _listItems.add(value);

  bool removeListItem({required String value}) {
    if (_listItems.contains(value)) {
      _listItems.remove(value);
      return true;
    }
    return false;
  }

  void removeLastListItem() {
    if (_listItems.isNotEmpty) {
      _listItems.removeLast();
    }
  }

  bool updateFirstWhereOrNull({
    required String testValue,
    required String updateValue,
  }) =>
      _listItems.updateFirstWhereOrNull(
        (value) => value == testValue,
        (_) => updateValue,
      ) !=
      null;

  // -------- MapInformer ---- MapInformer ---- MapInformer -------- \\

  void updateMapItems({required Map<String, String> values}) => _mapItems.update(values);

  void updateMapItemsKey({required String key, required String value}) =>
      _mapItems.updateKey(key, (_) => value, ifAbsent: () => value);

  void decrementMapItems() {
    print('''[🐛] [DEBUG] [🌟] [HomeViewModel.decrementMapItems] [📞] I was called''');
  }

  void incrementMapItems() {
    print('''[🐛] [DEBUG] [🌟] [HomeViewModel.incrementMapItems] [📞] I was called''');
  }


  // -------- UTIL ---- UTIL ---- UTIL -------- \\

  String get _randomGangstaLoremIpsum => ConstValues.randomGangstaLoremIpsum[random.nextInt(
        ConstValues.randomGangstaLoremIpsum.length,
      )];

  TextStyle get exampleTitleStyle => Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static HomeViewModel get locate => HomeViewModel();


}
