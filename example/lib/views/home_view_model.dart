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
  List<String> get listItems => _listItems.value;

  late final random = Random();

  @override
  Future<void> initialise() async {
    super.initialise();
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  void updateInformer({required int value}) => _counter.update(value);

  void decrementCounter() => _counter.updateCurrent((value) => --value);

  void incrementCounter() => _counter.updateCurrent((value) => ++value);

  void decrementListItems() => _listItems.updateCurrent((value) => value..removeLast());

  void incrementListItems() =>
      _listItems.updateCurrent((value) => value..add(_randomGangstaLoremIpsum));

  void updateListItems({required List<String> values}) => _listItems.update(values);

  String get _randomGangstaLoremIpsum => ConstValues.randomGangstaLoremIpsum[random.nextInt(
        ConstValues.randomGangstaLoremIpsum.length,
      )];

  TextStyle get exampleTitleStyle => Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static HomeViewModel get locate => HomeViewModel();
}
