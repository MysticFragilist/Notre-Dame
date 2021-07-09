// FLUTTER / DART / THIRD-PARTIES
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// MANAGERS
import 'package:notredame/core/managers/course_repository.dart';
import 'package:notredame/core/managers/settings_manager.dart';

// MODELS
import 'package:notredame/core/models/course.dart';
import 'package:notredame/core/models/session.dart';

// VIEW
import 'package:notredame/ui/views/dashboard_view.dart';
import 'package:notredame/ui/widgets/course_activity_tile.dart';
import 'package:notredame/ui/widgets/grade_button.dart';

// VIEWMODEL
import 'package:notredame/core/viewmodels/dashboard_viewmodel.dart';

// CONSTANTS
import 'package:notredame/core/constants/preferences_flags.dart';
import 'package:notredame/core/models/course_activity.dart';

// OTHERS
import '../../helpers.dart';

// MOCKS
import '../../mock/managers/course_repository_stub.dart';
import '../../mock/managers/settings_manager_stub.dart';

void main() {
  late SettingsManager settingsManager;
  late CourseRepository courseRepository;
  AppIntl? intl;
  DashboardViewModel viewModel;

  // Activities for today
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

  // Cards
  Map<PreferencesFlag, int> dashboard = {
    PreferencesFlag.aboutUsCard: 0,
    PreferencesFlag.scheduleCard: 1,
    PreferencesFlag.progressBarCard: 2,
    PreferencesFlag.gradesCard: 3
  };

  final numberOfCards = dashboard.entries.length;

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

  final Course courseSummer = Course(
      acronym: 'GEN101',
      group: '02',
      session: 'É2020',
      programCode: '999',
      grade: 'C+',
      numberOfCredits: 3,
      title: 'Cours générique');

  final Course courseSummer2 = Course(
      acronym: 'GEN102',
      group: '02',
      session: 'É2020',
      programCode: '999',
      grade: 'C+',
      numberOfCredits: 3,
      title: 'Cours générique');

  final Course courseWinter = Course(
      acronym: 'GEN101',
      group: '02',
      session: 'H2020',
      programCode: '999',
      grade: 'C+',
      numberOfCredits: 3,
      title: 'Cours générique');

  final Course courseFall = Course(
      acronym: 'GEN101',
      group: '02',
      session: 'A2020',
      programCode: '999',
      grade: 'C+',
      numberOfCredits: 3,
      title: 'Cours générique');

  final courses = [courseSummer, courseSummer2, courseWinter, courseFall];

  Future<void> longPressDrag(
      WidgetTester tester, Offset start, Offset end) async {
    final TestGesture drag = await tester.startGesture(start);
    await tester.pump(const Duration(seconds: 1));
    await drag.moveTo(end);
    await tester.pump(const Duration(seconds: 1));
    await drag.up();
  }

  group('DashboardView - ', () {
    setUp(() async {
      intl = await setupAppIntl();
      settingsManager = setupSettingsManagerMock();
      courseRepository = setupCourseRepositoryMock();
      setupNavigationServiceMock();
      courseRepository = setupCourseRepositoryMock();

      CourseRepositoryStub.stubSessions(
          courseRepository as CourseRepositoryStub,
          toReturn: [session]);
      CourseRepositoryStub.stubGetSessions(
          courseRepository as CourseRepositoryStub,
          toReturn: [session]);
      CourseRepositoryStub.stubActiveSessions(
          courseRepository as CourseRepositoryStub,
          toReturn: [session]);
      CourseRepositoryStub.stubCourses(
          courseRepository as CourseRepositoryStub);
      CourseRepositoryStub.stubGetCourses(
          courseRepository as CourseRepositoryStub,
          fromCacheOnly: true);
      CourseRepositoryStub.stubGetCourses(
          courseRepository as CourseRepositoryStub,
          fromCacheOnly: false);
      CourseRepositoryStub.stubCoursesActivities(
          courseRepository as CourseRepositoryStub);
      CourseRepositoryStub.stubGetCoursesActivities(
          courseRepository as CourseRepositoryStub,
          fromCacheOnly: true);
      CourseRepositoryStub.stubGetCoursesActivities(
          courseRepository as CourseRepositoryStub,
          fromCacheOnly: false);

      SettingsManagerStub.stubSetInt(
          settingsManager as SettingsManagerStub, PreferencesFlag.aboutUsCard);

      SettingsManagerStub.stubSetInt(
          settingsManager as SettingsManagerStub, PreferencesFlag.scheduleCard);

      SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
          PreferencesFlag.progressBarCard);

      SettingsManagerStub.stubSetInt(
          settingsManager as SettingsManagerStub, PreferencesFlag.gradesCard);

      viewModel = DashboardViewModel(intl: intl!);

      viewModel.todayDate = DateTime(2020);
    });

    tearDown(() {});

    group('UI - ', () {
      testWidgets('Has view title restore button and cards, displayed',
          (WidgetTester tester) async {
        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find Dashboard Title
        final dashboardTitle = find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(Text),
        );
        expect(dashboardTitle, findsOneWidget);

        // Find restoreCards Button
        final restoreCardsIcon = find.byIcon(Icons.restore);
        expect(restoreCardsIcon, findsOneWidget);

        // Find cards
        expect(find.byType(Card), findsNWidgets(numberOfCards));
      });

      testWidgets('Has card aboutUs displayed properly',
          (WidgetTester tester) async {
        CourseRepositoryStub.stubCoursesActivities(
            courseRepository as CourseRepositoryStub,
            toReturn: activities);

        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: true);
        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: false);

        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find aboutUs card
        final aboutUsCard = find.widgetWithText(Card, intl!.card_applets_title);
        expect(aboutUsCard, findsOneWidget);

        // Find aboutUs card Text Paragraph
        final aboutUsParagraph = find.textContaining(intl!.card_applets_text);
        expect(aboutUsParagraph, findsOneWidget);

        // Find aboutUs card Link Buttons
        final aboutUsLinkButtons = find.byType(TextButton);
        expect(aboutUsLinkButtons, findsNWidgets(3));

        expect(find.text(intl!.facebook.toUpperCase()), findsOneWidget);
        expect(find.text(intl!.github.toUpperCase()), findsOneWidget);
        expect(find.text(intl!.email.toUpperCase()), findsOneWidget);
      });

      testWidgets('Has card schedule displayed properly',
          (WidgetTester tester) async {
        CourseRepositoryStub.stubCoursesActivities(
            courseRepository as CourseRepositoryStub,
            toReturn: activities);

        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: true);
        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: false);

        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find schedule card in second position by its title
        final scheduleTitle = tester.firstWidget(find.descendant(
          of: find.byType(Dismissible).at(1),
          matching: find.byType(Text),
        ));
        expect((scheduleTitle as Text).data, intl!.title_schedule);

        // Find three activities in the card
        expect(
            find.descendant(
              of: find.byType(Dismissible),
              matching: find.byType(CourseActivityTile),
            ),
            findsNWidgets(3));
      });
    });

    group('Interactions - ', () {
      testWidgets('AboutUsCard is dismissible and can be restored',
          (WidgetTester tester) async {
        CourseRepositoryStub.stubCoursesActivities(
            courseRepository as CourseRepositoryStub);

        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: true);
        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: false);

        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
            PreferencesFlag.aboutUsCard);

        SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
            PreferencesFlag.scheduleCard);

        SettingsManagerStub.stubSetInt(
            settingsManager as SettingsManagerStub, PreferencesFlag.gradesCard);

        SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
            PreferencesFlag.progressBarCard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find Dismissible Cards
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));
        expect(find.text(intl!.card_applets_title), findsOneWidget);

        // Swipe Dismissible aboutUs Card horizontally
        await tester.drag(
            find.byType(Dismissible).first, const Offset(1000.0, 0.0));

        // Check that the card is now absent from the view
        await tester.pumpAndSettle();
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards - 1));
        expect(find.text(intl!.card_applets_title), findsNothing);

        // Tap the restoreCards button
        await tester.tap(find.byIcon(Icons.restore));

        await tester.pumpAndSettle();

        // Check that the card is now present in the view
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));
        expect(find.text(intl!.card_applets_title), findsOneWidget);
      });

      testWidgets('AboutUsCard is reorderable and can be restored',
          (WidgetTester tester) async {
        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        CourseRepositoryStub.stubCoursesActivities(
            courseRepository as CourseRepositoryStub);
        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: true);
        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: false);

        SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
            PreferencesFlag.aboutUsCard);

        SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
            PreferencesFlag.scheduleCard);

        SettingsManagerStub.stubSetInt(
            settingsManager as SettingsManagerStub, PreferencesFlag.gradesCard);

        SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
            PreferencesFlag.progressBarCard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find Dismissible Cards
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));

        // Find aboutUs card
        expect(find.text(intl!.card_applets_title), findsOneWidget);

        // Check that the aboutUs card is in the first position
        var text = tester.firstWidget(find.descendant(
          of: find.byType(Dismissible).first,
          matching: find.byType(Text),
        ));

        expect((text as Text).data, intl!.card_applets_title);

        // Long press then drag and drop card at the end of the list
        await longPressDrag(
            tester,
            tester.getCenter(find.text(intl!.card_applets_title)),
            tester.getCenter(find.text(intl!.progress_bar_title)) +
                const Offset(0.0, 1000));

        await tester.pumpAndSettle();

        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));

        // Check that the card is now in last position
        text = tester.firstWidget(find.descendant(
          of: find.byType(Dismissible).last,
          matching: find.byType(Text),
        ));
        expect(text.data, intl!.card_applets_title);

        // Tap the restoreCards button
        await tester.tap(find.byIcon(Icons.restore));

        await tester.pumpAndSettle();

        text = tester.firstWidget(find.descendant(
          of: find.byType(Dismissible).first,
          matching: find.byType(Text),
        ));

        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));

        // Check that the first card is now AboutUs
        expect(text.data, intl!.card_applets_title);
      });

      testWidgets('ScheduleCard is dismissible and can be restored',
          (WidgetTester tester) async {
        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find Dismissible Cards
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));
        expect(find.widgetWithText(Dismissible, intl!.title_schedule),
            findsOneWidget);

        // Swipe Dismissible schedule Card horizontally
        await tester.drag(
            find.byType(Dismissible).at(1), const Offset(1000.0, 0.0));

        // Check that the card is now absent from the view
        await tester.pumpAndSettle();

        expect(find.byType(Dismissible), findsNWidgets(numberOfCards - 1));
        expect(find.widgetWithText(Dismissible, intl!.title_schedule),
            findsNothing);

        // Tap the restoreCards button
        await tester.tap(find.byIcon(Icons.restore));

        await tester.pumpAndSettle();

        // Check that the card is now present in the view
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));
        expect(find.widgetWithText(Dismissible, intl!.title_schedule),
            findsOneWidget);
      });

      group('UI - gradesCard', () {
        testWidgets('Has card grades displayed - with no courses',
            (WidgetTester tester) async {
          SettingsManagerStub.stubGetDashboard(
              settingsManager as SettingsManagerStub,
              toReturn: dashboard);

          await tester.pumpWidget(localizedWidget(
              child: FeatureDiscovery(child: const DashboardView())));
          await tester.pumpAndSettle();

          // Find grades card
          final gradesCard = find.widgetWithText(Card, intl!.grades_title);
          expect(gradesCard, findsOneWidget);

          // Find grades card Title
          final gradesTitle = find.text(intl!.grades_title);
          expect(gradesTitle, findsOneWidget);

          // Find empty grades card
          final gradesEmptyTitle =
              find.text(intl!.grades_msg_no_grades.split("\n").first);
          expect(gradesEmptyTitle, findsOneWidget);
        });

        testWidgets('Has card grades displayed - with courses',
            (WidgetTester tester) async {
          CourseRepositoryStub.stubCourses(
              courseRepository as CourseRepositoryStub,
              toReturn: courses);
          CourseRepositoryStub.stubGetCourses(
              courseRepository as CourseRepositoryStub,
              fromCacheOnly: true,
              toReturn: courses);
          CourseRepositoryStub.stubGetCourses(
              courseRepository as CourseRepositoryStub,
              fromCacheOnly: false,
              toReturn: courses);

          SettingsManagerStub.stubGetDashboard(
              settingsManager as SettingsManagerStub,
              toReturn: dashboard);

          await tester.pumpWidget(localizedWidget(
              child: FeatureDiscovery(child: const DashboardView())));
          await tester.pumpAndSettle();

          // Find grades card
          final gradesCard = find.widgetWithText(Card, intl!.grades_title);
          expect(gradesCard, findsOneWidget);

          // Find grades card Title
          final gradesTitle = find.text(intl!.grades_title);
          expect(gradesTitle, findsOneWidget);

          // Find grades buttons in the card
          final gradesButtons = find.byType(GradeButton);
          expect(gradesButtons, findsNWidgets(2));
        });

        testWidgets('gradesCard is dismissible and can be restored',
            (WidgetTester tester) async {
          SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
              PreferencesFlag.aboutUsCard);

          SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
              PreferencesFlag.scheduleCard);

          SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
              PreferencesFlag.progressBarCard);

          SettingsManagerStub.stubSetInt(settingsManager as SettingsManagerStub,
              PreferencesFlag.gradesCard);
          SettingsManagerStub.stubGetDashboard(
              settingsManager as SettingsManagerStub,
              toReturn: dashboard);

          await tester.pumpWidget(localizedWidget(
              child: FeatureDiscovery(child: const DashboardView())));
          await tester.pumpAndSettle();

          // Find Dismissible Cards
          expect(find.byType(Dismissible), findsNWidgets(numberOfCards));
          expect(find.text(intl!.grades_title), findsOneWidget);

          // Swipe Dismissible grades Card horizontally
          await tester.drag(
              find.widgetWithText(Dismissible, intl!.grades_title),
              const Offset(1000.0, 0.0));

          // Check that the card is now absent from the view
          await tester.pumpAndSettle();
          expect(find.byType(Dismissible), findsNWidgets(numberOfCards - 1));
          expect(find.text(intl!.grades_title), findsNothing);

          // Tap the restoreCards button
          await tester.tap(find.byIcon(Icons.restore));

          await tester.pumpAndSettle();

          // Check that the card is now present in the view
          expect(find.byType(Dismissible), findsNWidgets(numberOfCards));
          expect(find.text(intl!.grades_title), findsOneWidget);
        });
      });
    });

    group("UI - progressBar", () {
      testWidgets('Has card progressBar displayed',
          (WidgetTester tester) async {
        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find progress card
        final progressCard =
            find.widgetWithText(Card, intl!.progress_bar_title);
        expect(progressCard, findsOneWidget);

        // Find progress card Title
        final progressTitle = find.text(intl!.progress_bar_title);
        expect(progressTitle, findsOneWidget);

        // Find progress card linearProgressBar
        final linearProgressBar = find.byType(LinearProgressIndicator);
        expect(linearProgressBar, findsOneWidget);
      });

      testWidgets('progressCard is dismissible and can be restored',
          (WidgetTester tester) async {
        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find Dismissible Cards
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));
        expect(find.text(intl!.progress_bar_title), findsOneWidget);

        // Swipe Dismissible progress Card horizontally
        await tester.drag(
            find.widgetWithText(Dismissible, intl!.progress_bar_title),
            const Offset(1000.0, 0.0));

        // Check that the card is now absent from the view
        await tester.pumpAndSettle();
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards - 1));
        expect(find.text(intl!.progress_bar_title), findsNothing);

        // Tap the restoreCards button
        await tester.tap(find.byIcon(Icons.restore));

        await tester.pumpAndSettle();

        // Check that the card is now present in the view
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));
        expect(find.text(intl!.progress_bar_title), findsOneWidget);
      });

      testWidgets('progressBarCard is reorderable and can be restored',
          (WidgetTester tester) async {
        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        // Find Dismissible Cards
        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));

        // Find progressBar card
        expect(find.text(intl!.progress_bar_title), findsOneWidget);

        // Check that the progressBar card is in the first position
        var text = tester.firstWidget(find.descendant(
          of: find.widgetWithText(Dismissible, intl!.progress_bar_title).first,
          matching: find.byType(Text),
        ));

        expect((text as Text).data, intl!.progress_bar_title);

        // Long press then drag and drop card at the end of the list
        await longPressDrag(
            tester,
            tester.getCenter(find.text(intl!.progress_bar_title)),
            tester.getCenter(find.text(intl!.card_applets_title)) +
                const Offset(0.0, 1000));

        await tester.pumpAndSettle();

        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));

        // Check that the card is now in last position
        text = tester.firstWidget(find.descendant(
          of: find.widgetWithText(Dismissible, intl!.progress_bar_title).last,
          matching: find.byType(Text),
        ));
        expect(text.data, intl!.progress_bar_title);

        // Tap the restoreCards button
        await tester.tap(find.byIcon(Icons.restore));

        await tester.pumpAndSettle();

        text = tester.firstWidget(find.descendant(
          of: find.widgetWithText(Dismissible, intl!.progress_bar_title).first,
          matching: find.byType(Text),
        ));

        expect(find.byType(Dismissible), findsNWidgets(numberOfCards));

        // Check that the first card is now AboutUs
        expect(text.data, intl!.progress_bar_title);
      });
    });

    group("golden - ", () {
      testWidgets("Applets Card", (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(800, 1410);

        dashboard = {
          PreferencesFlag.aboutUsCard: 0,
        };

        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        await expectLater(find.byType(DashboardView),
            matchesGoldenFile(goldenFilePath("dashboardView_appletsCard_1")));
      });

      testWidgets("Schedule card", (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(800, 1410);

        CourseRepositoryStub.stubCoursesActivities(
            courseRepository as CourseRepositoryStub);
        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: true);
        CourseRepositoryStub.stubGetCoursesActivities(
            courseRepository as CourseRepositoryStub,
            fromCacheOnly: false);

        dashboard = {
          PreferencesFlag.scheduleCard: 0,
        };

        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        await expectLater(find.byType(DashboardView),
            matchesGoldenFile(goldenFilePath("dashboardView_scheduleCard_1")));
      });
      testWidgets("progressBar Card", (WidgetTester tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(800, 1410);

        dashboard = {
          PreferencesFlag.progressBarCard: 0,
        };

        SettingsManagerStub.stubGetDashboard(
            settingsManager as SettingsManagerStub,
            toReturn: dashboard);

        await tester.pumpWidget(localizedWidget(
            child: FeatureDiscovery(child: const DashboardView())));
        await tester.pumpAndSettle();

        await expectLater(
            find.byType(DashboardView),
            matchesGoldenFile(
                goldenFilePath("dashboardView_progressBarCard_1")));
      });
    });
  });
}
