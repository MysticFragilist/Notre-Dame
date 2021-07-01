// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ROUTES
import 'package:notredame/core/constants/router_paths.dart';

// MANAGER
import 'package:notredame/core/managers/settings_manager.dart';
import 'package:notredame/core/services/navigation_service.dart';

// VIEWMODEL
import 'package:notredame/core/viewmodels/choose_language_viewmodel.dart';

// CONSTANTS
import 'package:notredame/core/constants/preferences_flags.dart';

// OTHERS
import '../helpers.dart';
import '../mock/managers/settings_manager_mock.dart';
import '../mock/services/navigation_service_mock.dart';

late ChooseLanguageViewModel viewModel;

void main() {
  late NavigationServiceMock navigationServiceMock;
  late SettingsManager settingsManager;

  group("ChooseLanguageViewModel - ", () {
    setUp(() async {
      // Setting up mocks
      navigationServiceMock = setupNavigationServiceMock();
      settingsManager = setupSettingsManagerMock();
      final AppIntl intl = await setupAppIntl();

      viewModel = ChooseLanguageViewModel(intl: intl);
      NavigationServiceMock.stubPop(navigationServiceMock);
      NavigationServiceMock.stubPushNamed(navigationServiceMock);
    });

    tearDown(() {
      unregister<NavigationService>();
      unregister<SettingsManager>();
    });

    group("changeLanguage - ", () {
      test('can set language english', () async {
        SettingsManagerMock.stubSetString(
            settingsManager as SettingsManagerMock, PreferencesFlag.theme);

        viewModel.changeLanguage(0);

        verify(settingsManager
            .setLocale(AppIntl.supportedLocales.first.languageCode));
        verify(navigationServiceMock.pop());
        verify(navigationServiceMock.pushNamed(RouterPaths.login));
      });

      test('can set language français', () async {
        SettingsManagerMock.stubSetString(
            settingsManager as SettingsManagerMock, PreferencesFlag.theme);

        viewModel.changeLanguage(1);

        verify(settingsManager
            .setLocale(AppIntl.supportedLocales.last.languageCode));
        verify(navigationServiceMock.pop());
        verify(navigationServiceMock.pushNamed(RouterPaths.login));
      });

      test('throws an error when index does not exist', () async {
        SettingsManagerMock.stubSetString(
            settingsManager as SettingsManagerMock, PreferencesFlag.theme);

        expect(() => viewModel.changeLanguage(-1), throwsException,
            reason: "No valid language for the index -1 passed in parameters");
      });
    });

    group("prop language - ", () {
      test('returns the languages successfully', () async {
        final languages = viewModel.languages;

        expect(['English', 'Français'], languages);
      });
    });
  });
}
