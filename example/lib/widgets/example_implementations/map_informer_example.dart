import 'package:flutter/material.dart';
import 'package:informers/informer.dart';

import '../../data/constants/const_durations.dart';
import '../../views/home_view_model.dart';
import '../examples/feature_example.dart';
import '../examples/method_example.dart';
import '../util/controller_box.dart';

class MapInformerExample extends StatefulWidget {
  const MapInformerExample({
    required this.model,
    super.key,
  });

  final HomeViewModel model;

  @override
  State<MapInformerExample> createState() => _MapInformerExampleState();
}

class _MapInformerExampleState extends State<MapInformerExample> {
  final ControllerBox _controllerBox = ControllerBox();

  final _removeFocusNode = FocusNode();
  final _updateKeyValuedFocusNode = FocusNode();
  final _putIfAbsentValueFocusNode = FocusNode();
  final Informer<String?> _updateErrorText = Informer(null, forceUpdate: false);
  final Informer<String?> _removeErrorText = Informer(null, forceUpdate: false);
  final Informer<String?> _updateKeyErrorText = Informer(null, forceUpdate: false);

  @override
  void dispose() {
    _controllerBox.dispose();
    _removeFocusNode.dispose();
    _updateKeyValuedFocusNode.dispose();
    _putIfAbsentValueFocusNode.dispose();
    _updateErrorText.dispose();
    _removeErrorText.dispose();
    _updateKeyErrorText.dispose();
    super.dispose();
  }

  void _tryUpdate(HomeViewModel model) {
    final value = _controllerBox.get(#update).text;
    try {
      if (value.isNotEmpty) {
        widget.model.updateMapItems(
          values: {
            for (final value in value.split(',').map(
              (mapEntry) {
                final mapEntrySplit = mapEntry.split(':');
                return MapEntry(mapEntrySplit.first, mapEntrySplit.last);
              },
            ))
              value.key: value.value
          },
        );
        _controllerBox.get(#update).clear();
        _updateErrorText.update(null);
        widget.model.focusNode.unfocus();
      }
    } catch (e) {
      _updateKeyErrorText.update('Use key:value,key:value');
    }
  }

  void _tryAdd(HomeViewModel model) {
    final value = _controllerBox.get(#add).text;
    if (value.isNotEmpty) {
      final valueSplit = value.split(':');
      widget.model.addMapItem(key: valueSplit.first, value: valueSplit.last);
      _controllerBox.get(#remove).text = value;
      _controllerBox.get(#add).clear();
      widget.model.focusNode.unfocus();
      _removeFocusNode.requestFocus();
    }
  }

  void _tryRemove(HomeViewModel model) {
    final success = widget.model.removeMapItem(key: _controllerBox.get(#remove).text);
    if (success) {
      _controllerBox.get(#remove).clear();
      _removeErrorText.update(null);
      widget.model.focusNode.unfocus();
    } else {
      _removeErrorText.update('Value not in the list, yo');
    }
  }

  void _updateKey(HomeViewModel model) {
    final key = _controllerBox.get(#updateKeyKey).text;
    final value = _controllerBox.get(#updateKeyValue).text;
    widget.model.updateMapItemsKey(key: key, value: value);
    _controllerBox.get(#updateKeyKey).clear();
    _controllerBox.get(#updateKeyValue).clear();
    _updateKeyErrorText.update(null);
    widget.model.focusNode.unfocus();
  }

  void _putIfAbsent(HomeViewModel model) {
    final key = _controllerBox.get(#putIfAbsentKeyKey).text;
    final value = _controllerBox.get(#putIfAbsentKeyValue).text;
    final containedKey = widget.model.mapItemsListenable.value.containsKey(key);
    final currentValue = widget.model.putIfAbsent(key: key, value: value);
    if (containedKey) {
      _controllerBox.get(#putIfAbsentKeyValue).text = currentValue;
    } else {
      _controllerBox.get(#putIfAbsentKeyKey).clear();
      _controllerBox.get(#putIfAbsentKeyValue).clear();
    }
    widget.model.focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureExample(
      title: 'MapInformer',
      child: Column(
        children: [
          const SizedBox(height: 16),
          MethodExample(
            title: '_mapItems.updateCurrent',
            child: Column(
              children: [
                ValueListenableBuilder<Map<String, String>>(
                  valueListenable: widget.model.mapItemsListenable,
                  builder: (context, mapItems, child) {
                    final mapItemsIsEmpty = mapItems.isEmpty;
                    return Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: AnimatedOpacity(
                                duration: ConstDurations.halfDefaultAnimationDuration,
                                opacity: mapItemsIsEmpty ? 0.3 : 1,
                                child: IgnorePointer(
                                  ignoring: mapItemsIsEmpty,
                                  child: ElevatedButton(
                                    onPressed: widget.model.decrementMapItems,
                                    child: AnimatedDefaultTextStyle(
                                      style: widget.model.textTheme.bodyText1!.copyWith(
                                        decoration: mapItemsIsEmpty
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
                                onPressed: widget.model.incrementMapItems,
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
                            '$mapItems',
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
            title: '_mapItems.update',
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
                          labelText: 'Update mapItems values',
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
            title: '_mapItems.add',
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
                          labelText: 'Add mapItems value',
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
            title: '_mapItems.remove',
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
                            labelText: 'Remove mapItems value',
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
            title: '_mapItems.updateKey',
            child: Transform.translate(
              offset: const Offset(0, -4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ValueListenableBuilder<Map<String, String>>(
                      valueListenable: widget.model.mapItemsListenable,
                      builder: (context, mapItems, child) => Text(
                        '$mapItems',
                        style: widget.model.exampleTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ValueListenableBuilder<String?>(
                      valueListenable: _updateKeyErrorText,
                      builder: (context, removeErrorText, child) => TextField(
                        controller: _controllerBox.get(#updateKeyKey),
                        decoration: InputDecoration(
                          labelText: 'Key to be updated',
                          errorText: removeErrorText,
                          alignLabelWithHint: true,
                        ),
                        onSubmitted: (_) => _updateKeyValuedFocusNode.requestFocus(),
                      ),
                    ),
                    TextField(
                      controller: _controllerBox.get(#updateKeyValue),
                      focusNode: _updateKeyValuedFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Updated value',
                        alignLabelWithHint: true,
                      ),
                      onSubmitted: (_) => _updateKey(widget.model),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _updateKey(widget.model),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          MethodExample(
            title: '_mapItems.putIfAbsent',
            child: Transform.translate(
              offset: const Offset(0, -4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ValueListenableBuilder<Map<String, String>>(
                      valueListenable: widget.model.mapItemsListenable,
                      builder: (context, mapItems, child) => Text(
                        '$mapItems',
                        style: widget.model.exampleTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextField(
                      controller: _controllerBox.get(#putIfAbsentKeyKey),
                      decoration: const InputDecoration(
                        labelText: 'Key to be put',
                        alignLabelWithHint: true,
                      ),
                      onSubmitted: (_) => _putIfAbsentValueFocusNode.requestFocus(),
                    ),
                    TextField(
                      controller: _controllerBox.get(#putIfAbsentKeyValue),
                      focusNode: _putIfAbsentValueFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Put value',
                        alignLabelWithHint: true,
                      ),
                      onSubmitted: (_) => _putIfAbsent(widget.model),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _putIfAbsent(widget.model),
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
