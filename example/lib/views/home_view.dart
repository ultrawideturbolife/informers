import 'package:example/widgets/example_implementations/informer_example.dart';
import 'package:example/widgets/example_implementations/map_informer_example.dart';
import 'package:flutter/material.dart';
import 'package:veto/base_view_model.dart';

import '../widgets/example_implementations/list_informer_example.dart';
import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String route = 'home-view';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>(
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
}
