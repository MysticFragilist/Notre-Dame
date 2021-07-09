// FLUTTER / DART / THIRD-PARTIES
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// MANAGER
import 'package:notredame/core/managers/course_repository.dart';

// VIEWS
import 'package:notredame/ui/views/student_view.dart';

//WIDGETS
import 'package:notredame/ui/widgets/base_scaffold.dart';

// HELPER
import '../../helpers.dart';

// MOCKS
import '../../mock/managers/course_repository_stub.dart';
import '../../mock/services/networking_service_stub.dart';

void main() {
  CourseRepository courseRepository;
  NetworkingServiceStub networkingService;

  group('StudentView - ', () {
    setUp(() async {
      setupNavigationServiceMock();
      networkingService = setupNetworkingServiceMock() as NetworkingServiceStub;
      courseRepository = setupCourseRepositoryMock();

      CourseRepositoryStub.stubCourses(
          courseRepository as CourseRepositoryStub);
      CourseRepositoryStub.stubGetCourses(
          courseRepository as CourseRepositoryStub,
          fromCacheOnly: false);
      CourseRepositoryStub.stubGetCourses(
          courseRepository as CourseRepositoryStub,
          fromCacheOnly: true);

      // Stub to simulate that the user has an active internet connection
      NetworkingServiceStub.stubHasConnectivity(networkingService);
    });

    tearDown(() {
      unregister<CourseRepository>();
      unregister<NetworkingServiceStub>();
    });

    group('UI - ', () {
      testWidgets('has Tab bar and sliverAppBar and BaseScaffold',
          (WidgetTester tester) async {
        await tester.pumpWidget(
            localizedWidget(child: FeatureDiscovery(child: StudentView())));
        await tester.pumpAndSettle();

        expect(find.byType(TabBar), findsOneWidget);

        expect(find.byType(SliverAppBar), findsOneWidget);

        expect(find.byType(BaseScaffold), findsOneWidget);
      });

      group("golden - ", () {
        testWidgets("default view (no events)", (WidgetTester tester) async {
          tester.binding.window.physicalSizeTestValue = const Size(800, 1410);

          await tester.pumpWidget(
              localizedWidget(child: FeatureDiscovery(child: StudentView())));
          await tester.pumpAndSettle();

          await expectLater(find.byType(StudentView),
              matchesGoldenFile(goldenFilePath("studentView_1")));
        });
      });
    });
  });
}
