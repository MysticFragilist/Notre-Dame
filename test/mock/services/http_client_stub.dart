// FLUTTER / DART / THIRD-PARTIES
import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../mocks_generators.mocks.dart';

/// Stub functions for the [MockHttpClient]
class HttpClientStub {
  /// Stub the next post of [url] and return [jsonResponse] with [statusCode] as http response code.
  static void stubJsonPost(MockHttpClient client, String url,
      Map<String, dynamic> jsonResponse, int statusCode) {
    when(client.post(Uri.parse(url),
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer(
            (_) async => http.Response(jsonEncode(jsonResponse), statusCode));
  }

  /// Stub the next post request to [url] and return [response] with [statusCode] as http response code.
  static void stubPost(MockHttpClient client, String url, String response,
      [int statusCode = 200]) {
    when(client.post(Uri.parse(url),
            headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response(response, statusCode));
  }
}
