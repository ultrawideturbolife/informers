import 'package:example/data/constants/const_durations.dart';
import 'package:example/widgets/feature_example.dart';
import 'package:example/widgets/method_example.dart';
import 'package:flutter/material.dart';
import 'package:veto/base_view_model.dart';

import '../views/home_view_model.dart';

class ListInformerExample extends StatelessWidget {
  const ListInformerExample({
    required this.model,
    super.key,
  });

  final HomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>(
      disposeViewModel: false,
      initialiseViewModel: false,
      builder: (context, model) {
        return FeatureExample(
          title: 'ListInformer',
          child: Column(
            children: [
              const SizedBox(height: 24),
              MethodExample(
                title: '_listItems.updateCurrent',
                child: Column(
                  children: [
                    ValueListenableBuilder<List<String>>(
                      valueListenable: model.listItemsListenable,
                      builder: (context, listItems, child) {
                        final listItemsIsEmpty = listItems.isEmpty;
                        return Column(
                          children: [
                            Text(
                              '$listItems',
                              style: model.exampleTitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: model.incrementListItems,
                                    child: const Text('ADD'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AnimatedOpacity(
                                    duration: ConstDurations.defaultAnimationDuration,
                                    opacity: listItemsIsEmpty ? 0.3 : 1,
                                    child: IgnorePointer(
                                      ignoring: listItemsIsEmpty,
                                      child: ElevatedButton(
                                        onPressed: model.decrementListItems,
                                        child: AnimatedDefaultTextStyle(
                                          style: model.textTheme.bodyText1!.copyWith(
                                            decoration: listItemsIsEmpty
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            color: Colors.white,
                                          ),
                                          duration: ConstDurations.defaultAnimationDuration,
                                          child: const Text('REMOVE'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => model,
    );
  }
}
