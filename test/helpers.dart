// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

// OTHER
import 'package:notredame/locator.dart';

// SERVICES / MANAGERS
import 'package:notredame/core/services/navigation_service.dart';
import 'package:notredame/core/services/analytics_service.dart';
import 'package:notredame/core/services/rive_animation_service.dart';
import 'package:notredame/core/services/mon_ets_api.dart';
import 'package:notredame/core/services/signets_api.dart';
import 'package:notredame/core/managers/user_repository.dart';
import 'package:notredame/core/managers/cache_manager.dart';
import 'package:notredame/core/services/preferences_service.dart';
import 'package:notredame/core/managers/course_repository.dart';
import 'package:notredame/core/services/github_api.dart';
import 'package:notredame/core/managers/settings_manager.dart';
import 'package:notredame/core/services/networking_service.dart';
import 'package:notredame/core/services/internal_info_service.dart';

// MOCK
import 'mocks_generators.mocks.dart';

/// Return the path of the [goldenName] file.
String goldenFilePath(String goldenName) => "./goldenFiles/$goldenName.png";

/// Unregister the service [T] from GetIt
void unregister<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

/// Load the l10n classes. Take the [child] widget to test
Widget localizedWidget(
        {required Widget child,
        bool useScaffold = true,
        String locale = 'en',
        double textScaleFactor = 0.9}) =>
    RepaintBoundary(
      child: MaterialApp(
        localizationsDelegates: const [
          AppIntl.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(locale),
        home: useScaffold ? Scaffold(body: child) : child,
      ),
    );

/// Load a mock of the [AnalyticsService]
MockAnalyticsService setupAnalyticsServiceMock() {
  unregister<AnalyticsService>();
  final service = MockAnalyticsService();

  locator.registerSingleton<AnalyticsService>(service);

  return service;
}

/// Load a mock of the [RiveAnimationService]
MockRiveAnimationService setupRiveAnimationServiceMock() {
  unregister<RiveAnimationService>();
  final service = MockRiveAnimationService();

  locator.registerSingleton<RiveAnimationService>(service);

  return service;
}

/// Load a mock of the [InternalInfoService]
MockInternalInfoService setupInternalInfoServiceMock() {
  unregister<InternalInfoService>();
  final service = MockInternalInfoService();

  locator.registerSingleton<InternalInfoService>(service);

  return service;
}

void setupFlutterToastMock() {
  const MethodChannel channel = MethodChannel('PonnamKarthik/fluttertoast');

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'showToast') {
      return true;
    }
  });
}

void tearDownFlutterToastMock() {
  const MethodChannel channel = MethodChannel('PonnamKarthik/fluttertoast');

  channel.setMockMethodCallHandler(null);
}

/// Load a mock of the [NavigationService]
MockNavigationService setupNavigationServiceMock() {
  unregister<NavigationService>();
  final service = MockNavigationService();

  locator.registerSingleton<NavigationService>(service);

  return service;
}

/// Load a mock of the [MonETSApi]
MockMonETSApi setupMonETSApiMock() {
  unregister<MonETSApi>();
  final service = MockMonETSApi();

  locator.registerSingleton<MonETSApi>(service);

  return service;
}

/// Load a mock of the [GithubApi]
MockGithubApi setupGithubApiMock() {
  unregister<GithubApi>();
  final service = MockGithubApi();

  locator.registerSingleton<GithubApi>(service);

  return service;
}

/// Load a mock of the [FlutterSecureStorage]
MockFlutterSecureStorage setupFlutterSecureStorageMock() {
  unregister<FlutterSecureStorage>();
  final service = MockFlutterSecureStorage();

  locator.registerSingleton<FlutterSecureStorage>(service);

  return service;
}

/// Load a mock of the [UserRepository]
MockUserRepository setupUserRepositoryMock() {
  unregister<UserRepository>();
  final service = MockUserRepository();

  locator.registerSingleton<UserRepository>(service);

  return service;
}

/// Load the Internationalization class
Future<AppIntl> setupAppIntl() async {
  return AppIntl.delegate.load(const Locale('en'));
}

/// Load a mock of the [SignetsApi]
MockSignetsApi setupSignetsApiMock() {
  unregister<SignetsApi>();
  final service = MockSignetsApi();

  locator.registerSingleton<SignetsApi>(service);

  return service;
}

/// Load a mock of the [CacheManager]
MockCacheManager setupCacheManagerMock() {
  unregister<CacheManager>();
  final service = MockCacheManager();

  locator.registerSingleton<CacheManager>(service);

  return service;
}

/// Load the [Logger]
Logger setupLogger() {
  unregister<Logger>();
  final service = Logger();
  Logger.level = Level.error;

  locator.registerSingleton<Logger>(service);

  return service;
}

/// Load a mock of the [PreferencesService]
MockPreferencesService setupPreferencesServiceMock() {
  unregister<PreferencesService>();
  final service = MockPreferencesService();

  locator.registerSingleton<PreferencesService>(service);

  return service;
}

/// Load a mock of the [SettingsManager]
MockSettingsManager setupSettingsManagerMock() {
  unregister<SettingsManager>();
  final service = MockSettingsManager();

  locator.registerSingleton<SettingsManager>(service);

  return service;
}

/// Load a mock of the [CourseRepository]
MockCourseRepository setupCourseRepositoryMock() {
  unregister<CourseRepository>();
  final service = MockCourseRepository();

  locator.registerSingleton<CourseRepository>(service);

  return service;
}

MockNetworkingService setupNetworkingServiceMock() {
  unregister<NetworkingService>();
  final service = MockNetworkingService();

  locator.registerSingleton<NetworkingService>(service);

  return service;
}
