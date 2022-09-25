import 'package:flutter/material.dart';
import 'package:veto/base_view_model.dart';

import 'home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String route = 'home-view';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>(
      builder: (context, model) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Informers Demo'),
          ),
          body: const Center(
            child: Text('Test'),
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel.locate,
    );
  }
}
