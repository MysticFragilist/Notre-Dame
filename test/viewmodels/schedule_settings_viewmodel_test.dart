// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:table_calendar/table_calendar.dart';

// VIEWMODEL
import 'package:notredame/core/viewmodels/schedule_settings_viewmodel.dart';

// CONSTANTS
import 'package:notredame/core/constants/preferences_flags.dart';

// OTHER
import '../helpers.dart';
import '../mock/managers/settings_manager_mock.dart';

late SettingsManagerMock settingsManagerMock;
late ScheduleSettingsViewModel viewModel;

void main() {
  // Needed to support FlutterToast.
  TestWidgetsFlutterBinding.ensureInitialized();

  final Map<PreferencesFlag, dynamic> settings = {
    PreferencesFlag.scheduleSettingsCalendarFormat: CalendarFormat.week,
    PreferencesFlag.scheduleSettingsStartWeekday: StartingDayOfWeek.monday,
    PreferencesFlag.scheduleSettingsShowTodayBtn: true
  };

  group("ScheduleSettingsViewModel - ", () {
    setUp(() {
      settingsManagerMock = setupSettingsManagerMock() as SettingsManagerMock;
      setupFlutterToastMock();
      viewModel = ScheduleSettingsViewModel();
    });

    group("futureToRun - ", () {
      test("The settings are correctly loaded and sets", () async {
        SettingsManagerMock.stubGetScheduleSettings(settingsManagerMock,
            toReturn: settings);

        expect(await viewModel.futureToRun(), settings);
        expect(viewModel.calendarFormat,
            settings[PreferencesFlag.scheduleSettingsCalendarFormat]);
        expect(viewModel.startingDayOfWeek,
            settings[PreferencesFlag.scheduleSettingsStartWeekday]);
        expect(viewModel.showTodayBtn,
            settings[PreferencesFlag.scheduleSettingsShowTodayBtn]);

        verify(settingsManagerMock.getScheduleSettings()).called(1);
        verifyNoMoreInteractions(settingsManagerMock);
      });
    });

    group("setter calendarFormat - ", () {
      test("calendarFormat is updated on the settings", () async {
        SettingsManagerMock.stubSetString(settingsManagerMock,
            PreferencesFlag.scheduleSettingsCalendarFormat);

        // Call the setter.
        viewModel.calendarFormat = CalendarFormat.twoWeeks;

        await untilCalled(settingsManagerMock.setString(
            PreferencesFlag.scheduleSettingsCalendarFormat, any));

        expect(viewModel.calendarFormat, CalendarFormat.twoWeeks);
        expect(viewModel.isBusy, false);

        verify(settingsManagerMock.setString(
                PreferencesFlag.scheduleSettingsCalendarFormat, any))
            .called(1);
        verifyNoMoreInteractions(settingsManagerMock);
      });
    });

    group("setter startingDayOfWeek - ", () {
      test("startingDayOfWeek is updated on the settings", () async {
        SettingsManagerMock.stubSetString(
            settingsManagerMock, PreferencesFlag.scheduleSettingsStartWeekday);

        // Call the setter.
        viewModel.startingDayOfWeek = StartingDayOfWeek.friday;

        await untilCalled(settingsManagerMock.setString(
            PreferencesFlag.scheduleSettingsStartWeekday, any));

        expect(viewModel.startingDayOfWeek, StartingDayOfWeek.friday);
        expect(viewModel.isBusy, false);

        verify(settingsManagerMock.setString(
                PreferencesFlag.scheduleSettingsStartWeekday, any))
            .called(1);
        verifyNoMoreInteractions(settingsManagerMock);
      });
    });

    group("setter showTodayBtn - ", () {
      test("showTodayBtn is updated on the settings", () async {
        SettingsManagerMock.stubSetString(
            settingsManagerMock, PreferencesFlag.scheduleSettingsStartWeekday);

        const expected = false;

        // Call the setter.
        viewModel.showTodayBtn = expected;

        await untilCalled(settingsManagerMock.setBool(
            PreferencesFlag.scheduleSettingsShowTodayBtn, any));

        expect(viewModel.showTodayBtn, expected);
        expect(viewModel.isBusy, false);

        verify(settingsManagerMock.setBool(
                PreferencesFlag.scheduleSettingsShowTodayBtn, any))
            .called(1);
        verifyNoMoreInteractions(settingsManagerMock);
      });
    });
  });
}
