// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';

// MOCK
import '../../mocks_generators.mocks.dart';

/// Stub functions for the [MockFlutterSecureStorage]
class FlutterSecureStorageStub {
  /// Stub the read function of [FlutterSecureStorage]
  static void stubRead(MockFlutterSecureStorage mock,
      {required String key, required String? valueToReturn}) {
    when(mock.read(key: key)).thenAnswer((_) async => valueToReturn);
  }
}
