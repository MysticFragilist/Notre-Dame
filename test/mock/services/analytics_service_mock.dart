// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/mockito.dart';

// SERVICE
import 'package:notredame/core/services/analytics_service.dart';

/// Mock for the [AnalyticsService]
class AnalyticsServiceMock extends Mock implements AnalyticsService {
  @override
  Future logError(String prefix, String? message) async =>
      super.noSuchMethod(Invocation.method(#logError, [prefix, message]),
          returnValue: Future) as Future;

  @override
  Future logEvent(String prefix, String? message) async =>
      super.noSuchMethod(Invocation.method(#logEvent, [prefix, message]),
          returnValue: Future) as Future;
}
