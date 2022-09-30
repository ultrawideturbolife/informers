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
  final _updateController = TextEditingController();
  final _addController = TextEditingController();
  final _removeController = TextEditingController();
  final _firstWhereTestController = TextEditingController();
  final _firstWhereUpdateController = TextEditingController();
  final _removeFocusNode = FocusNode();
  final _firstWhereUpdatedFocusNode = FocusNode();
  final Informer<String?> _removeErrorText = Informer(null, forceUpdate: false);
  final Informer<String?> _firstWhereErrorText = Informer(null, forceUpdate: false);

  @override
  void dispose() {
    _updateController.dispose();
    _addController.dispose();
    _removeController.dispose();
    _firstWhereTestController.dispose();
    _firstWhereUpdateController.dispose();
    _removeFocusNode.dispose();
    _firstWhereUpdatedFocusNode.dispose();
    _removeErrorText.dispose();
    super.dispose();
  }

  void _tryUpdate(HomeViewModel model) {
    final value = _updateController.text;
    if (value.isNotEmpty) {
      model.updateListItems(
        values: value.split(',').map((e) => e.toString().trim()).toList(),
      );
      _updateController.clear();
      model.focusNode.unfocus();
    }
  }

  void _tryAdd(HomeViewModel model) {
    final value = _addController.text;
    if (value.isNotEmpty) {
      model.addListItem(value: value);
      _removeController.text = value;
      _addController.clear();
      model.focusNode.unfocus();
      _removeFocusNode.requestFocus();
    }
  }

  void _tryRemove(HomeViewModel model) {
    final success = model.removeListItem(value: _removeController.text);
    if (success) {
      _removeController.clear();
      _removeErrorText.update(null);
      model.focusNode.unfocus();
    } else {
      _removeErrorText.update('Value not in the list, yo');
    }
  }

  void _tryUpdateFirstWhereOrNull(HomeViewModel model) {
    final testValue = _firstWhereTestController.text;
    final updateValue = _firstWhereUpdateController.text;
    final success = model.updateFirstWhereOrNull(testValue: testValue, updateValue: updateValue);
    if (success) {
      _firstWhereTestController.clear();
      _firstWhereUpdateController.clear();
      _firstWhereErrorText.update(null);
      model.focusNode.unfocus();
    } else {
      _firstWhereErrorText.update('Value not found, yo');
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
              const SizedBox(height: 16),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '$listItems',
                                style: model.exampleTitleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AnimatedOpacity(
                                    duration: ConstDurations.halfDefaultAnimationDuration,
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
                                          duration: ConstDurations.halfDefaultAnimationDuration,
                                          child: const Text('-'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: model.incrementListItems,
                                    child: const Text('+'),
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
              const SizedBox(height: 16),
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
                          child: TextField(
                            controller: _updateController,
                            decoration: const InputDecoration(
                              labelText: 'Update listItems values',
                              alignLabelWithHint: true,
                            ),
                            onSubmitted: (value) => _tryUpdate(model),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Transform.translate(
                          offset: const Offset(0, 12),
                          child: ElevatedButton(
                            onPressed: () => _tryUpdate(model),
                            child: const Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MethodExample(
                title: '_listItems.add',
                child: Transform.translate(
                  offset: const Offset(0, -4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _addController,
                            decoration: const InputDecoration(
                              labelText: 'Add listItems value',
                              alignLabelWithHint: true,
                            ),
                            onSubmitted: (_) => _tryAdd(model),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Transform.translate(
                          offset: const Offset(0, 12),
                          child: ElevatedButton(
                            onPressed: () => _tryAdd(model),
                            child: const Text('Add'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MethodExample(
                title: '_listItems.remove',
                child: Transform.translate(
                  offset: const Offset(0, -4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<String?>(
                            valueListenable: _removeErrorText,
                            builder: (context, removeErrorText, child) => TextField(
                              controller: _removeController,
                              focusNode: _removeFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Remove listItems value',
                                errorText: removeErrorText,
                                alignLabelWithHint: true,
                              ),
                              onSubmitted: (_) => _tryRemove(model),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Transform.translate(
                          offset: const Offset(0, 12),
                          child: ElevatedButton(
                            onPressed: () => _tryRemove(model),
                            child: const Text('Remove'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MethodExample(
                title: '_listItems.removeLast',
                child: Transform.translate(
                  offset: const Offset(0, -4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder<List<String>>(
                            valueListenable: model.listItemsListenable,
                            builder: (context, listItems, child) => AnimatedOpacity(
                              duration: ConstDurations.halfDefaultAnimationDuration,
                              opacity: listItems.isEmpty ? 0.3 : 1,
                              child: IgnorePointer(
                                ignoring: listItems.isEmpty,
                                child: ElevatedButton(
                                  onPressed: model.removeLast,
                                  child: const Text('Remove last'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MethodExample(
                title: '_listItems.updateFirstWhereOrNull',
                child: Transform.translate(
                  offset: const Offset(0, -4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ValueListenableBuilder<List<String>>(
                          valueListenable: model.listItemsListenable,
                          builder: (context, listItems, child) => Text(
                            '$listItems',
                            style: model.exampleTitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ValueListenableBuilder<String?>(
                          valueListenable: _firstWhereErrorText,
                          builder: (context, removeErrorText, child) => TextField(
                            controller: _firstWhereTestController,
                            decoration: InputDecoration(
                              labelText: 'Value to be updated',
                              errorText: removeErrorText,
                              alignLabelWithHint: true,
                            ),
                            onSubmitted: (_) => _firstWhereUpdatedFocusNode.requestFocus(),
                          ),
                        ),
                        TextField(
                          controller: _firstWhereUpdateController,
                          focusNode: _firstWhereUpdatedFocusNode,
                          decoration: const InputDecoration(
                            labelText: 'Updated value',
                            alignLabelWithHint: true,
                          ),
                          onSubmitted: (_) => _tryUpdateFirstWhereOrNull(model),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _tryUpdateFirstWhereOrNull(model),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => widget.model,
    );
  }
}
