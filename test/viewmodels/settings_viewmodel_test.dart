// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// MANAGER
import 'package:notredame/core/managers/settings_manager.dart';

// VIEWMODEL
import 'package:notredame/core/viewmodels/settings_viewmodel.dart';

// CONSTANTS
import 'package:notredame/core/constants/preferences_flags.dart';

// OTHERS
import '../helpers.dart';
import '../mock/managers/settings_manager_mock.dart';

late SettingsViewModel viewModel;

void main() {
  SettingsManager? settingsManager;

  group("SettingsViewModel - ", () {
    setUp(() async {
      // Setting up mocks
      settingsManager = setupSettingsManagerMock();
      final AppIntl intl = await setupAppIntl();

      viewModel = SettingsViewModel(intl: intl);
    });

    tearDown(() {
      unregister<SettingsManager>();
    });

    group("futureToRun - ", () {
      test("The settings are correctly loaded and sets", () async {
        SettingsManagerMock.stubGetString(
            settingsManager as SettingsManagerMock, PreferencesFlag.locale,
            toReturn: 'en');

        SettingsManagerMock.stubGetString(
            settingsManager as SettingsManagerMock, PreferencesFlag.theme,
            toReturn: ThemeMode.system.toString());

        await viewModel.futureToRun();
        expect(viewModel.currentLocale, 'English');
        expect(viewModel.selectedTheme, ThemeMode.system);

        verify(settingsManager!.getString(any!)).called(2);
        verifyNoMoreInteractions(settingsManager);
      });
    });

    group("setter theme - ", () {
      test("can set system theme option", () async {
        SettingsManagerMock.stubSetString(
            settingsManager as SettingsManagerMock, PreferencesFlag.theme);

        // Call the setter.
        viewModel.selectedTheme = ThemeMode.system;

        await untilCalled(settingsManager!.setThemeMode(ThemeMode.system));

        expect(viewModel.selectedTheme, ThemeMode.system);
        expect(viewModel.isBusy, false);

        verify(settingsManager!.setThemeMode(ThemeMode.system)).called(1);
        verifyNoMoreInteractions(settingsManager);
      });

      test("can set dark theme option", () async {
        SettingsManagerMock.stubSetString(
            settingsManager as SettingsManagerMock, PreferencesFlag.theme);

        // Call the setter.
        viewModel.selectedTheme = ThemeMode.dark;

        await untilCalled(settingsManager!.setThemeMode(ThemeMode.dark));

        expect(viewModel.selectedTheme, ThemeMode.dark);
        expect(viewModel.isBusy, false);

        verify(settingsManager!.setThemeMode(ThemeMode.dark)).called(1);
        verifyNoMoreInteractions(settingsManager);
      });

      test("can set light theme option", () async {
        SettingsManagerMock.stubSetString(
            settingsManager as SettingsManagerMock, PreferencesFlag.theme);

        // Call the setter.
        viewModel.selectedTheme = ThemeMode.light;

        await untilCalled(settingsManager!.setThemeMode(ThemeMode.light));

        expect(viewModel.selectedTheme, ThemeMode.light);
        expect(viewModel.isBusy, false);

        verify(settingsManager!.setThemeMode(ThemeMode.light)).called(1);
        verifyNoMoreInteractions(settingsManager);
      });
    });
  });
}
