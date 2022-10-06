import 'package:flutter/material.dart';
import 'package:informers/informer.dart';

import '../../main.dart';
import '../examples/feature_example.dart';
import '../examples/method_example.dart';

class InformerExample extends StatefulWidget {
  const InformerExample({
    required this.model,
    super.key,
  });

  final HomeViewModel model;

  @override
  State<InformerExample> createState() => _InformerExampleState();
}

class _InformerExampleState extends State<InformerExample> {
  final _informerUpdateController = TextEditingController();
  final Informer<String?> _counterErrorText =
      Informer(null, forceUpdate: false);

  @override
  void dispose() {
    _informerUpdateController.dispose();
    _counterErrorText.dispose();
    super.dispose();
  }

  void _tryUpdateInformer(HomeViewModel model) {
    final value = int.tryParse(_informerUpdateController.text);
    if (value != null) {
      model.updateCounter(value: value);
      _informerUpdateController.clear();
      _counterErrorText.update(null);
      model.focusNode.unfocus();
    } else {
      _counterErrorText.update('int only, yo');
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return FeatureExample(
      title: 'Informer',
      child: Column(
        children: [
          const SizedBox(height: 16),
          MethodExample(
            title: '_counter.updateCurrent',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: model.decrementCounter,
                    child: const Text('-'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ValueListenableBuilder<int>(
                        valueListenable: model.counterListenable,
                        builder: (context, counter, child) => Text(
                          '_counter: $counter',
                          textAlign: TextAlign.center,
                          style: model.exampleTitleStyle,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: model.incrementCounter,
                    child: const Text('+'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          MethodExample(
            title: '_counter.update',
            child: Transform.translate(
              offset: const Offset(0, -4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<String?>(
                        valueListenable: _counterErrorText,
                        builder: (context, counterErrorText, child) =>
                            TextField(
                          controller: _informerUpdateController,
                          decoration: InputDecoration(
                            errorText: counterErrorText,
                            labelText: 'New counter value',
                            alignLabelWithHint: true,
                          ),
                          onSubmitted: (value) => _tryUpdateInformer(model),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Transform.translate(
                      offset: const Offset(0, 12),
                      child: ElevatedButton(
                        onPressed: () => _tryUpdateInformer(model),
                        child: const Text('Update'),
                      ),
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
