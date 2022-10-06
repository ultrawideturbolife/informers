import 'dart:math';

import 'package:example/widgets/example_implementations/informer_example.dart';
import 'package:example/widgets/example_implementations/list_informer_example.dart';
import 'package:example/widgets/example_implementations/map_informer_example.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:informers/informer.dart';
import 'package:informers/list_informer.dart';
import 'package:informers/map_informer.dart';
import 'package:veto/base_view_model.dart';

import 'data/constants/const_values.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Informers',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String route = 'home-view';

  @override
  Widget build(BuildContext context) => ViewModelBuilder<HomeViewModel>(
        builder: (context, model) {
          return GestureDetector(
            onTap: model.focusNode.unfocus,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Informers Example Project'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    InformerExample(model: model),
                    ListInformerExample(model: model),
                    MapInformerExample(model: model),
                    const SizedBox(height: kBottomNavigationBarHeight),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => HomeViewModel.locate,
      );
}

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

  void updateListItems({required List<String> values}) =>
      _listItems.update(values);

  void decrementListItems() =>
      _listItems.updateCurrent((value) => value..removeLast());

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

  void addMapItem({required String key, required String value}) =>
      _mapItems.add(key, value);

  bool removeMapItem({required String key}) => _mapItems.remove(key) != null;

  void updateMapItems({required Map<String, String> values}) =>
      _mapItems.update(values);

  void updateMapItemsKey({required String key, required String value}) =>
      _mapItems.updateKey(key, (_) => value, ifAbsent: () => value);

  void decrementMapItems() => _mapItems.updateCurrent(
        (current) => current..remove(_mapItems.value.keys.last),
      );

  void incrementMapItems() {
    _mapItems.updateCurrent((current) =>
        current..[_randomGangstaLoremIpsum] = _randomGangstaLoremIpsum);
  }

  String putIfAbsent({required String key, required String value}) =>
      _mapItems.putIfAbsent(key, value);

  // -------- UTIL ---- UTIL ---- UTIL -------- \\

  String get _randomGangstaLoremIpsum =>
      ConstValues.randomGangstaLoremIpsum[random.nextInt(
        ConstValues.randomGangstaLoremIpsum.length,
      )];

  TextStyle get exampleTitleStyle =>
      Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          );

  static HomeViewModel get locate => HomeViewModel();
}
