// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/mockito.dart';

// SERVICE
import 'package:notredame/core/services/networking_service.dart';

/// Mock for the [NetworkingService]
class NetworkingServiceMock extends Mock implements NetworkingService {
  @override
  Future<bool> hasConnectivity() =>
      super.noSuchMethod(Invocation.method(#hasConnectivity, []),
          returnValue: Future<bool>.value(false)) as Future<bool>;

  /// Stub the user connection state
  static Future<void> stubHasConnectivity(NetworkingServiceMock service,
      {bool hasConnectivity = true}) async {
    when(service.hasConnectivity()).thenAnswer((_) async => hasConnectivity);
  }
}
