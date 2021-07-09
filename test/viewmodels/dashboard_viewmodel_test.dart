// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// CONSTANTS
import 'package:notredame/core/constants/preferences_flags.dart';

// MANAGERS
import 'package:notredame/core/managers/settings_manager.dart';
import 'package:notredame/core/models/course.dart';

// MODEL
import 'package:notredame/core/models/session.dart';
import 'package:notredame/core/models/course_activity.dart';

// SERVICE
import 'package:notredame/core/services/preferences_service.dart';

// VIEWMODEL
import 'package:notredame/core/viewmodels/dashboard_viewmodel.dart';

// OTHER
import '../helpers.dart';

// MOCKS
import '../mock/managers/course_repository_stub.dart';
import '../mock/managers/settings_manager_stub.dart';
import '../mock/services/preferences_service_stub.dart';

void main() {
  late PreferencesService preferenceServiceMock;
  late SettingsManagerStub settingsManagerMock;
  late CourseRepositoryStub courseRepositoryMock;
  late DashboardViewModel viewModel;

  final gen101 = CourseActivity(
      courseGroup: "GEN101",
      courseName: "Generic course",
      activityName: "TD",
      activityDescription: "Activity description",
      activityLocation: "location",
      startDateTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
      endDateTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 12));
  final gen102 = CourseActivity(
      courseGroup: "GEN102",
      courseName: "Generic course",
      activityName: "TD",
      activityDescription: "Activity description",
      activityLocation: "location",
      startDateTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 13),
      endDateTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 16));
  final gen103 = CourseActivity(
      courseGroup: "GEN103",
      courseName: "Generic course",
      activityName: "TD",
      activityDescription: "Activity description",
      activityLocation: "location",
      startDateTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 18),
      endDateTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 21));

  final List<CourseActivity> activities = [gen101, gen102, gen103];

  // Needed to support FlutterToast.
  TestWidgetsFlutterBinding.ensureInitialized();

  // Courses
  final Course courseSummer = Course(
      acronym: 'GEN101',
      group: '02',
      session: 'É2020',
      programCode: '999',
      grade: 'C+',
      numberOfCredits: 3,
      title: 'Cours générique');

  final Course courseSummer2 = Course(
      acronym: 'GEN106',
      group: '02',
      session: 'É2020',
      programCode: '999',
      grade: 'C+',
      numberOfCredits: 3,
      title: 'Cours générique');

  final courses = [courseSummer, courseSummer2];

  // Cards
  final Map<PreferencesFlag, int> dashboard = {
    PreferencesFlag.aboutUsCard: 0,
    PreferencesFlag.scheduleCard: 1,
    PreferencesFlag.progressBarCard: 2,
  };

  // Reorderered Cards
  final Map<PreferencesFlag, int> reorderedDashboard = {
    PreferencesFlag.aboutUsCard: 1,
    PreferencesFlag.scheduleCard: 2,
    PreferencesFlag.progressBarCard: 0,
  };

  // Reorderered Cards with hidden scheduleCard
  final Map<PreferencesFlag, int> hiddenCardDashboard = {
    PreferencesFlag.aboutUsCard: 0,
    PreferencesFlag.scheduleCard: -1,
    PreferencesFlag.progressBarCard: 1,
  };

  // Session
  final Session session = Session(
      shortName: "É2020",
      name: "Ete 2020",
      startDate: DateTime(2020).subtract(const Duration(days: 1)),
      endDate: DateTime(2020).add(const Duration(days: 1)),
      endDateCourses: DateTime(2022, 1, 10, 1, 1),
      startDateRegistration: DateTime(2017, 1, 9, 1, 1),
      deadlineRegistration: DateTime(2017, 1, 10, 1, 1),
      startDateCancellationWithRefund: DateTime(2017, 1, 10, 1, 1),
      deadlineCancellationWithRefund: DateTime(2017, 1, 11, 1, 1),
      deadlineCancellationWithRefundNewStudent: DateTime(2017, 1, 11, 1, 1),
      startDateCancellationWithoutRefundNewStudent: DateTime(2017, 1, 12, 1, 1),
      deadlineCancellationWithoutRefundNewStudent: DateTime(2017, 1, 12, 1, 1),
      deadlineCancellationASEQ: DateTime(2017, 1, 11, 1, 1));

  group("DashboardViewModel - ", () {
    setUp(() async {
      // Setting up mocks
      courseRepositoryMock =
          setupCourseRepositoryMock() as CourseRepositoryStub;
      settingsManagerMock = setupSettingsManagerMock() as SettingsManagerStub;
      preferenceServiceMock =
          setupPreferencesServiceMock() as PreferencesServiceStub;
      courseRepositoryMock =
          setupCourseRepositoryMock() as CourseRepositoryStub;

      setupFlutterToastMock();
      courseRepositoryMock =
          setupCourseRepositoryMock() as CourseRepositoryStub;

      viewModel = DashboardViewModel(intl: await setupAppIntl());
      CourseRepositoryStub.stubGetSessions(courseRepositoryMock,
          toReturn: [session]);
      CourseRepositoryStub.stubActiveSessions(courseRepositoryMock,
          toReturn: [session]);
      CourseRepositoryStub.stubCoursesActivities(courseRepositoryMock);
      CourseRepositoryStub.stubGetCoursesActivities(courseRepositoryMock,
          fromCacheOnly: true);
      CourseRepositoryStub.stubGetCoursesActivities(courseRepositoryMock,
          fromCacheOnly: false);
    });

    tearDown(() {
      unregister<SettingsManager>();
      tearDownFlutterToastMock();
    });

    group('futureToRunGrades -', () {
      test('first load from cache than call SignetsAPI to get the courses',
          () async {
        CourseRepositoryStub.stubSessions(courseRepositoryMock,
            toReturn: [session]);
        CourseRepositoryStub.stubGetSessions(courseRepositoryMock,
            toReturn: [session]);
        CourseRepositoryStub.stubActiveSessions(courseRepositoryMock,
            toReturn: [session]);
        CourseRepositoryStub.stubGetCourses(courseRepositoryMock,
            toReturn: courses, fromCacheOnly: true);

        CourseRepositoryStub.stubGetCourses(courseRepositoryMock,
            toReturn: courses);

        expect(await viewModel.futureToRunGrades(), courses);

        await untilCalled(courseRepositoryMock.sessions);
        await untilCalled(courseRepositoryMock.sessions);

        expect(viewModel.courses, courses);

        verifyInOrder([
          courseRepositoryMock.sessions,
          courseRepositoryMock.activeSessions,
          courseRepositoryMock.activeSessions,
          courseRepositoryMock.getCourses(fromCacheOnly: true),
          courseRepositoryMock.getCourses(),
        ]);

        verifyNoMoreInteractions(courseRepositoryMock);
      });

      test('Signets throw an error while trying to get courses', () async {
        CourseRepositoryStub.stubSessions(courseRepositoryMock,
            toReturn: [session]);
        CourseRepositoryStub.stubGetSessions(courseRepositoryMock,
            toReturn: [session]);
        CourseRepositoryStub.stubActiveSessions(courseRepositoryMock,
            toReturn: [session]);

        CourseRepositoryStub.stubGetCourses(courseRepositoryMock,
            toReturn: courses, fromCacheOnly: true);

        CourseRepositoryStub.stubGetCoursesException(courseRepositoryMock,
            fromCacheOnly: false);

        CourseRepositoryStub.stubGetCourses(courseRepositoryMock,
            toReturn: courses);

        expect(await viewModel.futureToRunGrades(), courses,
            reason:
                "Even if SignetsAPI call fails, should return the cache contents");

        await untilCalled(courseRepositoryMock.sessions);
        await untilCalled(courseRepositoryMock.sessions);

        expect(viewModel.courses, courses);

        verifyInOrder([
          courseRepositoryMock.sessions,
          courseRepositoryMock.activeSessions,
          courseRepositoryMock.activeSessions,
          courseRepositoryMock.getCourses(fromCacheOnly: true),
          courseRepositoryMock.getCourses(),
        ]);

        verifyNoMoreInteractions(courseRepositoryMock);
      });
    });

    group("futureToRun - ", () {
      test("The initial cards are correctly loaded", () async {
        CourseRepositoryStub.stubGetCoursesActivities(courseRepositoryMock);
        CourseRepositoryStub.stubCoursesActivities(courseRepositoryMock);

        SettingsManagerStub.stubGetDashboard(settingsManagerMock,
            toReturn: dashboard);

        await viewModel.futureToRun();
        expect(viewModel.cards, dashboard);
        expect(viewModel.cardsToDisplay, [
          PreferencesFlag.aboutUsCard,
          PreferencesFlag.scheduleCard,
          PreferencesFlag.progressBarCard
        ]);

        verify(settingsManagerMock.getDashboard()).called(1);
        verifyNoMoreInteractions(settingsManagerMock);
      });

      test("build the list todays activities sorted by time", () async {
        CourseRepositoryStub.stubGetCoursesActivities(courseRepositoryMock);
        CourseRepositoryStub.stubCoursesActivities(courseRepositoryMock,
            toReturn: activities);

        await viewModel.futureToRun();
        await viewModel.futureToRunSchedule();

        await untilCalled(courseRepositoryMock.getCoursesActivities());

        expect(viewModel.todayDateEvents, activities);

        verify(courseRepositoryMock.getCoursesActivities()).called(1);

        verify(courseRepositoryMock.getCoursesActivities(fromCacheOnly: true))
            .called(1);

        verify(courseRepositoryMock.coursesActivities).called(1);

        verify(settingsManagerMock.getDashboard()).called(1);

        verifyNoMoreInteractions(courseRepositoryMock);
        verifyNoMoreInteractions(settingsManagerMock);
      });

      test("An exception is thrown during the preferenceService call",
          () async {
        CourseRepositoryStub.stubGetCoursesActivities(courseRepositoryMock);
        CourseRepositoryStub.stubCoursesActivities(courseRepositoryMock);

        PreferencesServiceStub.stubException(
            preferenceServiceMock as PreferencesServiceStub,
            PreferencesFlag.aboutUsCard);
        PreferencesServiceStub.stubException(
            preferenceServiceMock as PreferencesServiceStub,
            PreferencesFlag.scheduleCard);
        PreferencesServiceStub.stubException(
            preferenceServiceMock as PreferencesServiceStub,
            PreferencesFlag.progressBarCard);

        await viewModel.futureToRun();
        expect(viewModel.cardsToDisplay, []);

        verify(settingsManagerMock.getDashboard()).called(1);
        verifyNoMoreInteractions(settingsManagerMock);
      });
    });

    group("futureToRunSessionProgressBar - ", () {
      test("There is an active session", () async {
        CourseRepositoryStub.stubActiveSessions(courseRepositoryMock,
            toReturn: [session]);
        SettingsManagerStub.stubGetDashboard(settingsManagerMock,
            toReturn: dashboard);
        viewModel.todayDate = DateTime(2020);
        await viewModel.futureToRunSessionProgressBar();
        expect(viewModel.progress, 0.5);
        expect(viewModel.sessionDays, [1, 2]);
      });

      test("Active session is null", () async {
        CourseRepositoryStub.stubActiveSessions(courseRepositoryMock);

        await viewModel.futureToRunSessionProgressBar();
        expect(viewModel.progress, 0.0);
        expect(viewModel.sessionDays, [0, 0]);
      });
    });

    group("interact with cards - ", () {
      test("can hide a card and reset cards to default layout", () async {
        SettingsManagerStub.stubSetInt(
            settingsManagerMock, PreferencesFlag.aboutUsCard);
        SettingsManagerStub.stubSetInt(
            settingsManagerMock, PreferencesFlag.scheduleCard);
        SettingsManagerStub.stubSetInt(
            settingsManagerMock, PreferencesFlag.progressBarCard);

        SettingsManagerStub.stubGetDashboard(settingsManagerMock,
            toReturn: dashboard);

        await viewModel.futureToRun();

        // Call the setter.
        viewModel.hideCard(PreferencesFlag.scheduleCard);

        await untilCalled(
            settingsManagerMock.setInt(PreferencesFlag.scheduleCard, -1));

        expect(viewModel.cards, hiddenCardDashboard);
        expect(viewModel.cardsToDisplay,
            [PreferencesFlag.aboutUsCard, PreferencesFlag.progressBarCard]);

        verify(settingsManagerMock.setInt(PreferencesFlag.scheduleCard, -1))
            .called(1);
        verify(settingsManagerMock.setInt(PreferencesFlag.aboutUsCard, 0))
            .called(1);
        verify(settingsManagerMock.setInt(PreferencesFlag.progressBarCard, 1))
            .called(1);

        // Call the setter.
        viewModel.setAllCardsVisible();

        await untilCalled(
            settingsManagerMock.setInt(PreferencesFlag.progressBarCard, 2));

        expect(viewModel.cards, dashboard);
        expect(viewModel.cardsToDisplay, [
          PreferencesFlag.aboutUsCard,
          PreferencesFlag.scheduleCard,
          PreferencesFlag.progressBarCard
        ]);

        verify(settingsManagerMock.getDashboard()).called(1);
        verify(settingsManagerMock.setInt(PreferencesFlag.aboutUsCard, 0))
            .called(1);
        verify(settingsManagerMock.setInt(PreferencesFlag.scheduleCard, 1))
            .called(1);
        verify(settingsManagerMock.setInt(PreferencesFlag.progressBarCard, 2))
            .called(1);
        verifyNoMoreInteractions(settingsManagerMock);
      });

      test("can set new order for cards", () async {
        CourseRepositoryStub.stubGetCoursesActivities(courseRepositoryMock);
        CourseRepositoryStub.stubCoursesActivities(courseRepositoryMock);

        SettingsManagerStub.stubGetDashboard(settingsManagerMock,
            toReturn: dashboard);

        SettingsManagerStub.stubSetInt(
            settingsManagerMock, PreferencesFlag.aboutUsCard);
        SettingsManagerStub.stubSetInt(
            settingsManagerMock, PreferencesFlag.scheduleCard);
        SettingsManagerStub.stubSetInt(
            settingsManagerMock, PreferencesFlag.progressBarCard);

        await viewModel.futureToRun();

        expect(viewModel.cards, dashboard);
        expect(viewModel.cardsToDisplay, [
          PreferencesFlag.aboutUsCard,
          PreferencesFlag.scheduleCard,
          PreferencesFlag.progressBarCard,
        ]);

        // Call the setter.
        viewModel.setOrder(PreferencesFlag.progressBarCard, 0);

        await untilCalled(
            settingsManagerMock.setInt(PreferencesFlag.progressBarCard, 0));

        expect(viewModel.cards, reorderedDashboard);
        expect(viewModel.cardsToDisplay, [
          PreferencesFlag.progressBarCard,
          PreferencesFlag.aboutUsCard,
          PreferencesFlag.scheduleCard
        ]);

        verify(settingsManagerMock.getDashboard()).called(1);
        verify(settingsManagerMock.setInt(PreferencesFlag.progressBarCard, 0))
            .called(1);
        verify(settingsManagerMock.setInt(PreferencesFlag.aboutUsCard, 1))
            .called(1);
        verify(settingsManagerMock.setInt(PreferencesFlag.scheduleCard, 2))
            .called(1);
        verifyNoMoreInteractions(settingsManagerMock);
      });
    });
  });
}
