import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/gherkin_unit_test.dart';
import 'package:informers/informer.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/notify_mock.dart';

class InformerFeature extends UnitFeature<Informer> {
  InformerFeature()
      : super(
          description: 'Informer',
          scenarios: [
            UnitScenario(
              systemUnderTest: (_) => Informer(null),
              examples: [
                const UnitExample(values: [0, 1]),
                const UnitExample(values: [10, 100]),
                const UnitExample(values: [-10, 50]),
              ],
              description: 'Using the Informer.update to update a value',
              setUpEach: (mocks, systemUnderTest) =>
                  systemUnderTest.update(null),
              steps: [
                Given(
                  'the informer value is at starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final startingValue = example!.firstValue();
                    systemUnderTest.update(startingValue);
                    expect(systemUnderTest.value, startingValue);
                  },
                ),
                When(
                  'the informer value gets updated to a new value with updateCurrent',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final newValue = example!.secondValue();
                    systemUnderTest.update(newValue);
                    log.info('Informer updated!');
                    box.write(#newValue, newValue);
                  },
                ),
                Then(
                  'the informer should have the new value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final newValue = box.read(#newValue);
                    expect(systemUnderTest.value, newValue);
                  },
                ),
              ],
            ),
            UnitScenario(
              systemUnderTest: (mocks) => Informer(null),
              examples: [
                const UnitExample(values: [0, 1]),
                const UnitExample(values: [-20, 5]),
                const UnitExample(values: [100, 20]),
              ],
              description:
                  'Using the Informer.updateCurrent to increment the current value',
              steps: [
                Given(
                  'the informer value is at starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final startingValue = example!.firstValue();
                    systemUnderTest.update(startingValue);
                    expect(systemUnderTest.value, startingValue);
                    box.write(#startingValue, startingValue);
                  },
                ),
                When(
                  'the informer value gets incremented X times with updateCurrent',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final nrOfIncrements = example!.secondValue();
                    for (int increment = 0;
                        increment < nrOfIncrements;
                        increment++) {
                      systemUnderTest.updateCurrent((value) => ++value);
                    }
                    log.info('Informer updated!');
                    box.write(#nrOfIncrements, nrOfIncrements);
                  },
                ),
                Then(
                  'the informer should have its original value incremented X times',
                  (systemUnderTest, log, box, mocks, [example]) {
                    expect(
                        systemUnderTest.value,
                        box.read<int>(#startingValue) +
                            box.read<int>(#nrOfIncrements));
                  },
                ),
              ],
            ),
            UnitScenario(
              examples: [
                const UnitExample(values: [0, 1]),
                const UnitExample(values: [0, 0]),
              ],
              systemUnderTest: (mocks) => Informer(null, forceUpdate: false),
              description:
                  'Using the Informer.update method without forceUpdate',
              setUpEach: (mocks, systemUnderTest) {
                final mock = NotifyMock();
                systemUnderTest.addListener(mock.notifyListeners);
                mocks.write(mock);
              },
              tearDownEach: (mocks, systemUnderTest) =>
                  systemUnderTest.removeListener(
                      mocks.read<NotifyMock>(NotifyMock).notifyListeners),
              steps: [
                Given(
                  'the informer value is at starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final int startingValue = example.firstValue();
                    systemUnderTest.update(startingValue);
                    expect(systemUnderTest.value, startingValue);
                    box.write(#startingValue, startingValue);
                  },
                ),
                WhenThen(
                  'I update the informer with a new value '
                  'then notifyListeners should have only been called if the value was different',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final newValue = example.secondValue();
                    systemUnderTest.update(newValue);
                    verify(mocks.read<NotifyMock>(NotifyMock).notifyListeners())
                        .called(
                            box.read<int>(#startingValue) != newValue ? 2 : 1);
                  },
                )
              ],
            ),
            UnitScenario(
              examples: [
                const UnitExample(values: [0, 1]),
                const UnitExample(values: [0, 0]),
              ],
              systemUnderTest: (mocks) => Informer(null, forceUpdate: false),
              description:
                  'Using the Informer.updateCurrent method without forceUpdate',
              setUpEach: (mocks, systemUnderTest) {
                final mock = NotifyMock();
                systemUnderTest.addListener(mock.notifyListeners);
                mocks.write(mock);
              },
              tearDownEach: (mocks, systemUnderTest) =>
                  systemUnderTest.removeListener(
                      mocks.read<NotifyMock>(NotifyMock).notifyListeners),
              steps: [
                Given(
                  'the informer value is at starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final int startingValue = example.firstValue();
                    systemUnderTest.updateCurrent((_) => startingValue);
                    expect(systemUnderTest.value, startingValue);
                    box.write(#startingValue, startingValue);
                  },
                ),
                WhenThen(
                  'I updateCurrent the informer with an addedValue '
                  'then notifyListeners should have only been called if the end result'
                  'was different from the starting value',
                  (systemUnderTest, log, box, mocks, [example]) {
                    final addedValue = example.secondValue();
                    systemUnderTest
                        .updateCurrent((value) => value + addedValue);
                    verify(mocks.read<NotifyMock>(NotifyMock).notifyListeners())
                        .called(box.read<int>(#startingValue) != addedValue
                            ? 2
                            : 1);
                  },
                )
              ],
            ),
          ],
        );
}
