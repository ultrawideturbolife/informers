import 'package:flutter/foundation.dart';
import 'package:informers/informers.dart';
import 'package:veto/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  final Informer<int> _counter = Informer(0);
  ValueListenable<int> get counterListenable => _counter;

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

  static HomeViewModel get locate => HomeViewModel();
}
