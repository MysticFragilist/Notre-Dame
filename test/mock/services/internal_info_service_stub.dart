// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/mockito.dart';

// MOCK
import '../../mocks_generators.mocks.dart';

/// Stub functions for the [MockInternalInfoService]
class InternalInfoServiceStub {
  /// Stub the answer of [fromPlatform]
  static void stubGetDeviceInfoForErrorReporting(MockInternalInfoService mock) {
    when(mock.getDeviceInfoForErrorReporting())
        .thenAnswer((_) async => "error");
  }
}
