// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';

// MANAGER
import 'package:notredame/core/managers/settings_manager.dart';

// MODEL
import 'package:notredame/core/constants/preferences_flags.dart';

class SettingsManagerMock extends Mock implements SettingsManager {
  @override
  Future<bool> setBool(PreferencesFlag flag, bool? value) async =>
      super.noSuchMethod(Invocation.method(#setBool, [flag, value]),
          returnValue: Future<bool>.value(true)) as Future<bool>;

  @override
  Future<bool> setInt(PreferencesFlag flag, int? value) async =>
      super.noSuchMethod(Invocation.method(#setInt, [flag, value]),
          returnValue: Future<bool>.value(true)) as Future<bool>;

  @override
  Future<bool> setString(PreferencesFlag flag, String? value) async =>
      super.noSuchMethod(Invocation.method(#setString, [flag, value]),
          returnValue: Future<bool>.value(true)) as Future<bool>;

  @override
  Future<String?> getString(PreferencesFlag? flag) async =>
      super.noSuchMethod(Invocation.method(#getString, [flag]),
          returnValue: Future<String?>.value()) as Future<String?>;

  /// Stub the [getScheduleSettings] function of [mock], when called return [toReturn].
  static void stubGetScheduleSettings(SettingsManagerMock mock,
      {Map<PreferencesFlag, dynamic> toReturn = const {}}) {
    when(mock.getScheduleSettings()).thenAnswer((_) async => toReturn);
  }

  /// Stub the [getDashboard] function of [mock], when called return [toReturn].
  static void stubGetDashboard(SettingsManagerMock mock,
      {Map<PreferencesFlag, int> toReturn = const {}}) {
    when(mock.getDashboard()).thenAnswer((_) async => toReturn);
  }

  /// Stub the [setString] function of [mock], when called with [flag] return [toReturn].
  static void stubSetString(SettingsManagerMock mock, PreferencesFlag flag,
      {bool toReturn = true}) {
    when(mock.setString(flag, any)).thenAnswer((_) async => toReturn);
  }

  /// Stub the [getString] function of [mock], when called with [flag] return [toReturn].
  static void stubGetString(SettingsManagerMock mock, PreferencesFlag flag,
      {String toReturn = 'test'}) {
    when(mock.getString(flag)).thenAnswer((_) async => toReturn);
  }

  /// Stub the [setBool] function of [mock], when called with [flag] return [toReturn].
  static void stubSetBool(SettingsManagerMock mock, PreferencesFlag flag,
      {bool toReturn = true}) {
    when(mock.setBool(flag, any)).thenAnswer((_) async => toReturn);
  }

  /// Stub the [setInt] function of [mock], when called with [flag] return [toReturn].
  static void stubSetInt(SettingsManagerMock mock, PreferencesFlag flag,
      {bool toReturn = true}) {
    when(mock.setInt(flag, any)).thenAnswer((_) async => toReturn);
  }

  /// Stub the [locale] function of [mock], when called return [toReturn].
  static void stubLocale(SettingsManagerMock mock,
      {Locale toReturn = const Locale('en')}) {
    when(mock.locale).thenReturn(toReturn);
  }
}
