import 'package:flutter/foundation.dart';

/// Wrapper class used to expose the [ChangeNotifier.notifyListeners] method.
abstract class InformNotifier extends ChangeNotifier {
  /// Used to force notify the listeners of this super [ChangeNotifier].
  void rebuild() => notifyListeners();
}
