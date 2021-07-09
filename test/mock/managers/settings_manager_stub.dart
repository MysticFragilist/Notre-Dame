// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';

// MODEL
import 'package:notredame/core/constants/preferences_flags.dart';

// MOCK
import '../../mocks_generators.mocks.dart';

/// Stub function for the [MockSettingsManager]
class SettingsManagerStub {
  /// Stub the [getScheduleSettings] function of [mock], when called return [toReturn].
  static void stubGetScheduleSettings(MockSettingsManager mock,
      {Map<PreferencesFlag, dynamic> toReturn = const {}}) {
    when(mock.getScheduleSettings()).thenAnswer((_) async => toReturn);
  }

  /// Stub the [getDashboard] function of [mock], when called return [toReturn].
  static void stubGetDashboard(MockSettingsManager mock,
      {Map<PreferencesFlag, int> toReturn = const {}}) {
    when(mock.getDashboard()).thenAnswer((_) async => toReturn);
  }

  /// Stub the [setString] function of [mock], when called with [flag] return [toReturn].
  static void stubSetString(MockSettingsManager mock, PreferencesFlag flag,
      {bool toReturn = true}) {
    when(mock.setString(flag, any)).thenAnswer((_) async => toReturn);
  }

  /// Stub the [getString] function of [mock], when called with [flag] return [toReturn].
  static void stubGetString(MockSettingsManager mock, PreferencesFlag flag,
      {String toReturn = 'test'}) {
    when(mock.getString(flag)).thenAnswer((_) async => toReturn);
  }

  /// Stub the [setBool] function of [mock], when called with [flag] return [toReturn].
  static void stubSetBool(MockSettingsManager mock, PreferencesFlag flag,
      {bool toReturn = true}) {
    when(mock.setBool(flag, any)).thenAnswer((_) async => toReturn);
  }

  /// Stub the [setInt] function of [mock], when called with [flag] return [toReturn].
  static void stubSetInt(MockSettingsManager mock, PreferencesFlag flag,
      {bool toReturn = true}) {
    when(mock.setInt(flag, any)).thenAnswer((_) async => toReturn);
  }

  /// Stub the [locale] function of [mock], when called return [toReturn].
  static void stubLocale(MockSettingsManager mock,
      {Locale toReturn = const Locale('en')}) {
    when(mock.locale).thenReturn(toReturn);
  }
}
