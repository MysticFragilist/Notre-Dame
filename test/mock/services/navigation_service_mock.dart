// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/mockito.dart';

// SERVICE
import 'package:notredame/core/services/navigation_service.dart';

/// Mock for the [NavigationService]
class NavigationServiceMock extends Mock implements NavigationService {
  @override
  bool pop() =>
      super.noSuchMethod(Invocation.method(#pop, []), returnValue: true)
          as bool;

  @override
  Future<dynamic> pushNamed(String? routeName, {dynamic arguments}) =>
      super.noSuchMethod(
          Invocation.method(#pop, [routeName], {#arguments: arguments}),
          returnValue: Future<dynamic>.value()) as Future<dynamic>;

  /// Stub the [pop] function of [mock], when called return [toReturn].
  static void stubPop(NavigationServiceMock mock, {bool toReturn = true}) {
    when(mock.pop()).thenAnswer((_) => toReturn);
  }

  /// Stub the [pushNamed] function of [mock], when called return [toReturn].
  static void stubPushNamed(NavigationServiceMock mock,
      {dynamic toReturn = Null}) {
    when(mock.pushNamed(any))
        .thenAnswer((_) => Future<dynamic>.value(toReturn));
  }
}
