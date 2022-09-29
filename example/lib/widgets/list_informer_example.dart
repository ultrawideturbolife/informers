import 'package:example/data/constants/const_durations.dart';
import 'package:example/widgets/feature_example.dart';
import 'package:example/widgets/method_example.dart';
import 'package:flutter/material.dart';
import 'package:informers/informer.dart';
import 'package:veto/base_view_model.dart';

import '../views/home_view_model.dart';

class ListInformerExample extends StatefulWidget {
  const ListInformerExample({
    required this.model,
    super.key,
  });

  final HomeViewModel model;

  @override
  State<ListInformerExample> createState() => _ListInformerExampleState();
}

class _ListInformerExampleState extends State<ListInformerExample> {
  final _listInformerUpdateController = TextEditingController();
  final Informer<String?> _listInformerErrorText = Informer(null, forceUpdate: false);

  @override
  void dispose() {
    _listInformerUpdateController.dispose();
    _listInformerErrorText.dispose();
    super.dispose();
  }

  void _tryUpdateListInformer(HomeViewModel model) {
    final List<String> values;
    try {
      values =
          _listInformerUpdateController.text.split(',').map((e) => e.toString().trim()).toList();
      model.updateListItems(values: values);
      _listInformerUpdateController.clear();
      _listInformerErrorText.update(null);
      model.focusNode.unfocus();
    } catch (e) {
      _listInformerErrorText.update('Strings only, yo');
    }
  }

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
              const SizedBox(height: 24),
              MethodExample(
                title: '_listItems.update',
                child: Transform.translate(
                  offset: const Offset(0, -4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<String?>(
                            valueListenable: _listInformerErrorText,
                            builder: (context, counterErrorText, child) => TextField(
                              controller: _listInformerUpdateController,
                              decoration: InputDecoration(
                                errorText: counterErrorText,
                                labelText: 'New listItems values',
                                alignLabelWithHint: true,
                              ),
                              onSubmitted: (value) => _tryUpdateListInformer(model),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Transform.translate(
                          offset: const Offset(0, 12),
                          child: ElevatedButton(
                            onPressed: () => _tryUpdateListInformer(model),
                            child: const Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => widget.model,
    );
  }
}
