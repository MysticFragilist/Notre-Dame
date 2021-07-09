// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/annotations.dart';

// SERVICES
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notredame/core/managers/cache_manager.dart';
import 'package:notredame/core/managers/course_repository.dart';
import 'package:notredame/core/managers/settings_manager.dart';
import 'package:notredame/core/managers/user_repository.dart';
import 'package:notredame/core/services/analytics_service.dart';
import 'package:notredame/core/services/github_api.dart';
import 'package:notredame/core/services/internal_info_service.dart';
import 'package:notredame/core/services/mon_ets_api.dart';
import 'package:notredame/core/services/navigation_service.dart';
import 'package:notredame/core/services/networking_service.dart';
import 'package:notredame/core/services/preferences_service.dart';
import 'package:notredame/core/services/rive_animation_service.dart';
import 'package:notredame/core/services/signets_api.dart';
import 'package:notredame/core/viewmodels/login_viewmodel.dart';
import 'package:http/http.dart' as http;

Future<dynamic> logAnalytics(String? prefix, String? message) =>
    Future<dynamic>.value();

@GenerateMocks([
  CacheManager,
  CourseRepository,
  SettingsManager,
  UserRepository,
  FlutterSecureStorage,
  GithubApi,
  InternalInfoService,
  MonETSApi,
  NavigationService,
  NetworkingService,
  PreferencesService,
  RiveAnimationService,
  SignetsApi,
  LoginViewModel
], customMocks: [
  // Allows to give a custom name to the http.Client
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<AnalyticsService>(
      fallbackGenerators: {#logEvent: logAnalytics, #logError: logAnalytics})
])
void main() {}
