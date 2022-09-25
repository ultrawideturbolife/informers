import 'package:flutter/foundation.dart';
import 'package:informers/informer.dart';
import 'package:informers/list_informer.dart';
import 'package:informers/map_informer.dart';
import 'package:veto/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  
  final Informer<int> _count = Informer(0);
  ValueListenable<int> get count => _count;

  final ListInformer<String> _names = ListInformer([]);
  ValueListenable<List<String>> get names => _names;

  final MapInformer<String, bool> _stringBool = MapInformer({});
  ValueListenable<Map<String, bool>> get stringBool => _stringBool;

  void increment() => _count.updateCurrent((value) => value + 1);

  void reset() => _count.update(0);


  @override
  Future<void> initialise({arguments}) async {
    super.initialise();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static HomeViewModel get locate => HomeViewModel();
}
