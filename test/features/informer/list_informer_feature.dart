import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/gherkin_unit_test.dart';
import 'package:informers/informers.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/notify_mock.dart';

class ListInformerFeature extends UnitFeature<ListInformer<String>> {
  ListInformerFeature()
      : super(
          description: 'ListInformer',
          systemUnderTest: (_) => ListInformer([]),
          setUpEach: (mocks, systemUnderTest) => systemUnderTest!.clear(),
          scenarios: [
            UnitScenario(
              examples: [
                const UnitExample(
                  values: [
                    <String>[],
                    ['newList']
                  ],
                ),
                const UnitExample(
                  values: [
                    ['yo', 'ok'],
                    ['another', 'new', 'list']
                  ],
                ),
              ],
              description: 'Using the ListInformer.update to update the list',
              steps: [
                Given(
                  'the list informer is at starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final startingValue = example.firstValue();
                    log.info(
                        'Settings starting value of the list informer as $startingValue..');
                    systemUnderTest.update(startingValue);
                    expect(systemUnderTest.value, startingValue);
                    log.success('Starting value set!');
                  },
                ),
                When(
                  'the list informer value gets updated with a new value with ListInformer.update',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final newValue = example.secondValue();
                    log.info(
                        'Setting the value of the ListInformer to the new value of $newValue..');
                    systemUnderTest.update(newValue);
                    log.success('New value set!');
                    box.write(#newValue, newValue);
                  },
                ),
                Then(
                  'the list informer should have the new value as its value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final newValue = box.read<List<String>>(#newValue);
                    log.info(
                        'Checking if value of ListInformer has updated to new value: $newValue.. ');
                    expect(systemUnderTest.value, newValue);
                    log.success('ListInformer has the new value!');
                  },
                )
              ],
            ),
            UnitScenario(
              systemUnderTest: (mocks) =>
                  ListInformer(List.empty(growable: true)),
              examples: [
                const UnitExample(values: [
                  ['firstList'],
                  'valueToBeAddedToTheList'
                ]),
                const UnitExample(values: [
                  ['firstList', 'ok', 'anotherValue'],
                  'valueToBeAddedToTheList'
                ]),
              ],
              description:
                  'Using the Informer.updateCurrent to increment the current value',
              steps: [
                Given(
                  'the list informer value is at starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final startingValues = example!.firstValue();
                    systemUnderTest.update(startingValues);
                    expect(systemUnderTest.value, startingValues);
                    box.write(#startingValues, startingValues);
                  },
                ),
                When(
                  'the list informer gets a value added with the updateCurrent method',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final valueToBeAdded = example.secondValue();
                    systemUnderTest.updateCurrent(
                        (current) => [...current, valueToBeAdded]);
                    box.write(#valueToBeAdded, valueToBeAdded);
                  },
                ),
                Then(
                  'the list informer should contain both the starting value and the value that was added',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info(systemUnderTest.value.toString());
                    for (final startingValue
                        in box.read<List<String>>(#startingValues)) {
                      expect(systemUnderTest.contains(startingValue), true);
                    }
                    expect(systemUnderTest.contains(box.read(#valueToBeAdded)),
                        true);
                  },
                ),
              ],
            ),
            UnitScenario(
              description: 'Using the ListInformer.add method to add a value',
              examples: [
                const UnitExample(
                  values: [
                    'start',
                    'end',
                  ],
                )
              ],
              steps: [
                Given(
                  'the ListInformer is at starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info('Setting starting value..');
                    final startingValue = example.firstValue();
                    systemUnderTest.update([startingValue]);
                    expect(systemUnderTest.contains(startingValue), true);
                    log.success('Starting value is set!');
                    box.write(1, startingValue);
                  },
                ),
                When(
                  'the ListInformer gets its value updated with the ListInformer.add method',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info('Adding new value with add method..');
                    final valueToBeAdded = example.secondValue();
                    systemUnderTest.add(valueToBeAdded);
                    log.success('New value added!');
                    box.write(2, valueToBeAdded);
                  },
                ),
                Then(
                  'the ListInformer should have both the starting value and the value that was added',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.contains(box.read(1)), true);
                    expect(systemUnderTest.contains(box.read(2)), true);
                  },
                )
              ],
            ),
            UnitScenario(
              description:
                  'Using the ListInformer.remove method to remove a value',
              examples: [
                UnitExample(
                  values: [
                    List<String>.from(['start', 'middle', 'end'],
                        growable: true),
                    'end',
                  ],
                )
              ],
              steps: [
                Given(
                  'the ListInformer is at starting values',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info('Setting starting values..');
                    final startingValues = example.firstValue();
                    systemUnderTest.update(startingValues);
                    for (final startingValue in startingValues) {
                      expect(systemUnderTest.contains(startingValue), true);
                    }
                    log.success('Starting value is set!');
                  },
                ),
                When(
                  'the ListInformer gets its values updated with the ListInformer.removed method',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info(
                        'Removing value with the ListInformer.remove method..');
                    final valueToBeRemoved = example.secondValue();
                    systemUnderTest.remove(valueToBeRemoved);
                    log.success('Value removed!');
                    box.write(1, valueToBeRemoved);
                  },
                ),
                Then(
                  'the ListInformer should not contain the value that was removed',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.contains(box.read(1)), false);
                  },
                )
              ],
            ),
            UnitScenario(
              description:
                  'Using the ListInformer.removeLast method to remove a value',
              examples: [
                UnitExample(
                  values: [
                    List<String>.from(['start', 'middle', 'end'],
                        growable: true),
                  ],
                )
              ],
              steps: [
                Given(
                  'the ListInformer is at starting values',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info('Setting starting values..');
                    final startingValues = example.firstValue();
                    systemUnderTest.update(startingValues);
                    for (final startingValue in startingValues) {
                      expect(systemUnderTest.contains(startingValue), true);
                    }
                    log.success('Starting value is set!');
                  },
                ),
                When(
                  'the ListInformer gets its last value removed with the ListInformer.removeLast method',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info(
                        'Removing value with the ListInformer.remove method..');
                    final valueThatWasRemoved = systemUnderTest.removeLast();
                    box.write(1, valueThatWasRemoved);
                    log.success('Last value removed!');
                  },
                ),
                Then(
                  'the ListInformer should not contain the value that was removed',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.contains(box.read(1)), false);
                  },
                )
              ],
            ),
            UnitScenario(
              description:
                  'Using the ListInformer.updateFirstWhereOrNull method to remove a value',
              examples: [
                UnitExample(
                  values: [
                    List<String>.from(['start', 'middle', 'end'],
                        growable: true),
                    ['end', 'anotherMiddle']
                  ],
                ),
                UnitExample(
                  values: [
                    List<String>.from(['start', 'middle', 'end'],
                        growable: true),
                    ['thisWillNotUpdate', 'noItWont']
                  ],
                ),
              ],
              steps: [
                Given(
                  'the ListInformer is at starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info('Setting starting values..');
                    final startingValues = example.firstValue();
                    systemUnderTest.update(startingValues);
                    for (final startingValue in startingValues) {
                      expect(systemUnderTest.contains(startingValue), true);
                    }
                    log.success('Starting value is set!');
                  },
                ),
                When(
                  'the ListInformer tries to update its values with Informer.updateFirstWhereOrNull method',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info(
                        'Updating ListInformer values with Informer.updateFirstWhereOrNull method..');
                    final List<String> valuesToBeUpdated =
                        example.secondValue();
                    final result = systemUnderTest.updateFirstWhereOrNull(
                      (value) => value == valuesToBeUpdated.first,
                      (_) => valuesToBeUpdated.last,
                    );
                    box.write(1, result != null);
                    box.write(2, valuesToBeUpdated.last);
                    log.info('Informer.updateFirstWhereOrNull call succeeded!');
                  },
                ),
                Then(
                  '''the ListInformer should only be updated if 'firstWhere' test was true''',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.contains(box.read(2)), box.read(1));
                  },
                )
              ],
            ),
            UnitScenario(
              description:
                  'existing value should notifyListeners when forceUpdate is true',
              systemUnderTest: (mocks) =>
                  ListInformer<String>([], forceUpdate: true),
              setUpEach: (mocks, systemUnderTest) {
                final mock = NotifyMock();
                systemUnderTest.update(['start']);
                systemUnderTest.addListener(mock.notifyListeners);
                mocks.write(mock);
              },
              tearDownEach: (mocks, systemUnderTest) {
                systemUnderTest.removeListener(
                    mocks.read<NotifyMock>(NotifyMock).notifyListeners);
              },
              steps: [
                Given(
                  'the ListInformer has a value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(systemUnderTest.isNotEmpty, true);
                    log.success('ListInformer has a value!');
                  },
                ),
                When(
                  'the ListInformer get updated with its two update methods, '
                  'with the same value, '
                  'while forceUpdate is true',
                  (systemUnderTest, log, box, mocks, [example]) {
                    log.info(
                        'Updating the ListInformer with the current value');
                    final startingValue = systemUnderTest.value;
                    systemUnderTest.update(startingValue);
                    expect(systemUnderTest.value, startingValue);
                    systemUnderTest.updateCurrent((current) => current);
                    expect(systemUnderTest.value, startingValue);
                    log.success(
                        'System under test has same value after update!');
                  },
                ),
                Then(
                  'notifyListeners should have been called twice despite it being the value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    verify(mocks.read<NotifyMock>(NotifyMock).notifyListeners())
                        .called(2);
                  },
                )
              ],
            ),
          ],
        );
}
