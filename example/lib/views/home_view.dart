import 'package:example/widgets/informer_example.dart';
import 'package:example/widgets/map_informer_example.dart';
import 'package:flutter/material.dart';
import 'package:veto/base_view_model.dart';

import '../widgets/list_informer_example.dart';
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
      rebuild: false,
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
                  const SizedBox(height: 24),
                  InformerExample(model: model),
                  const SizedBox(height: 24),
                  ListInformerExample(model: model),
                  const SizedBox(height: 24),
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
