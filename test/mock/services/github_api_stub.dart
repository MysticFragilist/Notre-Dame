// FLUTTER / DART / THIRD-PARTIES
import 'dart:io';
import 'package:mockito/mockito.dart';

// UTILS
import '../../mocks_generators.mocks.dart';

/// Stub functions for the [MockGithubApi]
class GithubApiStub {
  /// Stub the localFile of propertie [localFile] and return [fileToReturn].
  static void stubLocalFile(MockGithubApi client, File fileToReturn) {
    when(client.localFile).thenAnswer((_) async => fileToReturn);
  }
}
