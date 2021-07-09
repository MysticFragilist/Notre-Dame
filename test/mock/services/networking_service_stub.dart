// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/mockito.dart';

// SERVICE
import '../../mocks_generators.mocks.dart';

/// Stub functions for the [MockNetworkingService]
class NetworkingServiceStub {
  /// Stub the user connection state
  static Future<void> stubHasConnectivity(MockNetworkingService service,
      {bool hasConnectivity = true}) async {
    when(service.hasConnectivity()).thenAnswer((_) async => hasConnectivity);
  }
}
