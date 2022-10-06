import 'package:example/data/constants/const_durations.dart';
import 'package:example/widgets/examples/feature_example.dart';
import 'package:example/widgets/examples/method_example.dart';
import 'package:example/widgets/util/controller_box.dart';
import 'package:flutter/material.dart';
import 'package:informers/informer.dart';

import '../../main.dart';

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
  final ControllerBox _controllerBox = ControllerBox();

  final _removeFocusNode = FocusNode();
  final _firstWhereUpdatedFocusNode = FocusNode();
  final Informer<String?> _removeErrorText = Informer(null, forceUpdate: false);
  final Informer<String?> _firstWhereErrorText =
      Informer(null, forceUpdate: false);

  @override
  void dispose() {
    _controllerBox.dispose();
    _removeFocusNode.dispose();
    _firstWhereUpdatedFocusNode.dispose();
    _removeErrorText.dispose();
    super.dispose();
  }

  void _tryUpdate(HomeViewModel model) {
    final value = _controllerBox.get(#update).text;
    if (value.isNotEmpty) {
      widget.model.updateListItems(
        values: value.split(',').map((e) => e.toString().trim()).toList(),
      );
      _controllerBox.get(#update).clear();
      widget.model.focusNode.unfocus();
    }
  }

  void _tryAdd(HomeViewModel model) {
    final value = _controllerBox.get(#add).text;
    if (value.isNotEmpty) {
      widget.model.addListItem(value: value);
      _controllerBox.get(#remove).text = value;
      _controllerBox.get(#add).clear();
      widget.model.focusNode.unfocus();
      _removeFocusNode.requestFocus();
    }
  }

  void _tryRemove(HomeViewModel model) {
    final success =
        widget.model.removeListItem(value: _controllerBox.get(#remove).text);
    if (success) {
      _controllerBox.get(#remove).clear();
      _removeErrorText.update(null);
      widget.model.focusNode.unfocus();
    } else {
      _removeErrorText.update('Value not in the list, yo');
    }
  }

  void _tryUpdateFirstWhereOrNull(HomeViewModel model) {
    final testValue = _controllerBox.get(#firstWhereTest).text;
    final updateValue = _controllerBox.get(#firstWhereUpdate).text;
    final success = widget.model
        .updateFirstWhereOrNull(testValue: testValue, updateValue: updateValue);
    if (success) {
      _controllerBox.get(#firstWhereTest).clear();
      _controllerBox.get(#firstWhereUpdate).clear();
      _firstWhereErrorText.update(null);
      widget.model.focusNode.unfocus();
    } else {
      _firstWhereErrorText.update('Value not found, yo');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  valueListenable: widget.model.listItemsListenable,
                  builder: (context, listItems, child) {
                    final listItemsIsEmpty = listItems.isEmpty;
                    return Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: AnimatedOpacity(
                                duration:
                                    ConstDurations.halfDefaultAnimationDuration,
                                opacity: listItemsIsEmpty ? 0.3 : 1,
                                child: IgnorePointer(
                                  ignoring: listItemsIsEmpty,
                                  child: ElevatedButton(
                                    onPressed: widget.model.decrementListItems,
                                    child: AnimatedDefaultTextStyle(
                                      style: widget.model.textTheme.bodyText1!
                                          .copyWith(
                                        decoration: listItemsIsEmpty
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: Colors.white,
                                      ),
                                      duration: ConstDurations
                                          .halfDefaultAnimationDuration,
                                      child: const Text('-'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: widget.model.incrementListItems,
                                child: const Text('+'),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$listItems',
                            style: widget.model.exampleTitleStyle,
                            textAlign: TextAlign.center,
                          ),
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
                      child: TextField(
                        controller: _controllerBox.get(#update),
                        decoration: const InputDecoration(
                          labelText: 'Update listItems values',
                          alignLabelWithHint: true,
                        ),
                        onSubmitted: (value) => _tryUpdate(widget.model),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Transform.translate(
                      offset: const Offset(0, 12),
                      child: ElevatedButton(
                        onPressed: () => _tryUpdate(widget.model),
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
                        controller: _controllerBox.get(#add),
                        decoration: const InputDecoration(
                          labelText: 'Add listItems value',
                          alignLabelWithHint: true,
                        ),
                        onSubmitted: (_) => _tryAdd(widget.model),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Transform.translate(
                      offset: const Offset(0, 12),
                      child: ElevatedButton(
                        onPressed: () => _tryAdd(widget.model),
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
                          controller: _controllerBox.get(#remove),
                          focusNode: _removeFocusNode,
                          decoration: InputDecoration(
                            labelText: 'Remove listItems value',
                            errorText: removeErrorText,
                            alignLabelWithHint: true,
                          ),
                          onSubmitted: (_) => _tryRemove(widget.model),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Transform.translate(
                      offset: const Offset(0, 12),
                      child: ElevatedButton(
                        onPressed: () => _tryRemove(widget.model),
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
                        valueListenable: widget.model.listItemsListenable,
                        builder: (context, listItems, child) => AnimatedOpacity(
                          duration: ConstDurations.halfDefaultAnimationDuration,
                          opacity: listItems.isEmpty ? 0.3 : 1,
                          child: IgnorePointer(
                            ignoring: listItems.isEmpty,
                            child: ElevatedButton(
                              onPressed: widget.model.removeLastListItem,
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
                      valueListenable: widget.model.listItemsListenable,
                      builder: (context, listItems, child) => Text(
                        '$listItems',
                        style: widget.model.exampleTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ValueListenableBuilder<String?>(
                      valueListenable: _firstWhereErrorText,
                      builder: (context, removeErrorText, child) => TextField(
                        controller: _controllerBox.get(#firstWhereTest),
                        decoration: InputDecoration(
                          labelText: 'Value to be updated',
                          errorText: removeErrorText,
                          alignLabelWithHint: true,
                        ),
                        onSubmitted: (_) =>
                            _firstWhereUpdatedFocusNode.requestFocus(),
                      ),
                    ),
                    TextField(
                      controller: _controllerBox.get(#firstWhereUpdate),
                      focusNode: _firstWhereUpdatedFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Updated value',
                        alignLabelWithHint: true,
                      ),
                      onSubmitted: (_) =>
                          _tryUpdateFirstWhereOrNull(widget.model),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _tryUpdateFirstWhereOrNull(widget.model),
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
  }
}
