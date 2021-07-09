// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notredame/core/services/analytics_service.dart';
import 'package:rive/rive.dart';

// SERVICES / MANAGERS
import 'package:notredame/core/services/navigation_service.dart';
import 'package:notredame/core/services/rive_animation_service.dart';

// VIEW MODEL
import 'package:notredame/core/viewmodels/not_found_viewmodel.dart';

// OTHER
import 'package:notredame/core/constants/router_paths.dart';
import '../helpers.dart';
import '../mock/services/rive_animation_service_stub.dart';
import '../mocks_generators.mocks.dart';

void main() {
  late MockNavigationService navigationServiceMock;
  late MockRiveAnimationService riveAnimationServiceMock;
  late MockAnalyticsService analyticsServiceMock;

  late NotFoundViewModel viewModel;

  group('NotFoundViewModel - ', () {
    const String _pageNotFoundPassed = "/test";
    const String riveFileName = 'dot_jumping';

    setUp(() async {
      navigationServiceMock = setupNavigationServiceMock();
      riveAnimationServiceMock = setupRiveAnimationServiceMock();
      analyticsServiceMock = setupAnalyticsServiceMock();
      setupLogger();

      viewModel = NotFoundViewModel(pageName: _pageNotFoundPassed);
    });

    tearDown(() {
      unregister<NavigationService>();
      unregister<AnalyticsService>();
      unregister<RiveAnimationService>();
    });

    group('constructor - ', () {
      test('test that an analytics event is lauch', () async {
        const String pageTestCtor = "\testctor";
        NotFoundViewModel(pageName: pageTestCtor);

        verify(analyticsServiceMock.logEvent(NotFoundViewModel.tag,
            "An unknown page ($pageTestCtor) has been access from the app."));
      });
    });

    group('navigateToDashboard - ', () {
      test('navigating back worked', () async {
        viewModel.navigateToDashboard();

        verify(navigationServiceMock.pushNamed(RouterPaths.dashboard));
      });
    });

    group('notFoundPageName prop - ', () {
      test('get the page pass in parameter', () async {
        final notFoundName = viewModel.notFoundPageName;

        expect(_pageNotFoundPassed, notFoundName);
      });
    });

    group('artboard prop - ', () {
      test('get the rive artboard when empty', () async {
        final artboard = viewModel.artboard;

        expect(artboard, null);
      });

      test('get the rive artboard when there is an instance', () async {
        final expectedArtboard = Artboard();

        RiveAnimationServiceStub.stubLoadRiveFile(
            riveAnimationServiceMock, 'dot_jumping', expectedArtboard);

        await viewModel.loadRiveAnimation();
        final artboard = viewModel.artboard;

        expect(artboard, expectedArtboard);
      });
    });

    group('loadRiveAnimation - ', () {
      test('load the dot_jumping Rive animation successfuly', () async {
        await viewModel.loadRiveAnimation();

        verify(
            riveAnimationServiceMock.loadRiveFile(riveFileName: riveFileName));
      });

      test('load file Rive animation with error', () async {
        RiveAnimationServiceStub.stubLoadRiveFileException(
            riveAnimationServiceMock);

        await viewModel.loadRiveAnimation();

        verify(analyticsServiceMock.logError(NotFoundViewModel.tag,
            "An Error has occured during rive animation $riveFileName loading."));
      });
    });

    group('startRiveAnimation - ', () {
      test('start Rive animation with error', () async {
        final artboard = Artboard();

        RiveAnimationServiceStub.stubLoadRiveFile(
            riveAnimationServiceMock, 'dot_jumping', artboard);

        RiveAnimationServiceStub.stubAddControllerToAnimationException(
            riveAnimationServiceMock, artboard);

        await viewModel.loadRiveAnimation();
        viewModel.startRiveAnimation();

        verify(analyticsServiceMock.logError(NotFoundViewModel.tag,
            "An Error has occured during rive animation start."));
      });
    });
  });
}
