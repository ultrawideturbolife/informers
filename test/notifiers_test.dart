import 'package:gherkin_unit_test/gherkin_unit_test.dart';

import 'features/informer/informer_feature.dart';
import 'features/informer/list_informer_feature.dart';

void main() {
  NotifiersTest().test();
}

class NotifiersTest extends UnitTest {
  NotifiersTest()
      : super(
          description: 'All tests of the Informer package',
          features: [
            InformerFeature(),
            ListInformerFeature(),
          ],
        );
}
