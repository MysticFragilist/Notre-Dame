// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/mockito.dart';

// MODELS
import 'package:notredame/core/models/course_activity.dart';
import 'package:notredame/core/models/session.dart';
import 'package:notredame/core/models/course.dart';

// EXCEPTIONS
import 'package:notredame/core/utils/api_exception.dart';

// MOCK
import '../../mocks_generators.mocks.dart';

/// Stub functions for the [MockCourseRepository]
class CourseRepositoryStub {
  /// Stub the getter [coursesActivities] of [mock] when called will return [toReturn].
  static void stubCoursesActivities(MockCourseRepository mock,
      {List<CourseActivity?> toReturn = const []}) {
    when(mock.coursesActivities).thenReturn(toReturn as List<CourseActivity>?);
  }

  /// Stub the getter [sessions] of [mock] when called will return [toReturn].
  static void stubSessions(MockCourseRepository mock,
      {List<Session> toReturn = const []}) {
    when(mock.sessions).thenReturn(toReturn);
  }

  /// Stub the getter [activeSessions] of [mock] when called will return [toReturn].
  static void stubActiveSessions(MockCourseRepository mock,
      {List<Session> toReturn = const []}) {
    when(mock.activeSessions).thenReturn(toReturn);
  }

  /// Stub the function [getCoursesActivities] of [mock] when called will return [toReturn].
  static void stubGetCoursesActivities(MockCourseRepository mock,
      {List<CourseActivity> toReturn = const [], bool? fromCacheOnly}) {
    when(mock.getCoursesActivities(
            fromCacheOnly: fromCacheOnly ?? anyNamed("fromCacheOnly")))
        .thenAnswer((_) async => toReturn);
  }

  /// Stub the function [getCoursesActivities] of [mock] when called will throw [toThrow].
  static void stubGetCoursesActivitiesException(MockCourseRepository mock,
      {Exception toThrow =
          const ApiException(prefix: 'ApiException', message: ''),
      bool? fromCacheOnly}) {
    when(mock.getCoursesActivities(
            fromCacheOnly: fromCacheOnly ?? anyNamed("fromCacheOnly")))
        .thenAnswer((_) => Future.delayed(const Duration(milliseconds: 50))
            .then((value) => throw toThrow));
  }

  /// Stub the function [getSessions] of [mock] when called will return [toReturn].
  static void stubGetSessions(MockCourseRepository mock,
      {List<Session> toReturn = const []}) {
    when(mock.getSessions()).thenAnswer((_) async => toReturn);
  }

  /// Stub the function [getSessions] of [mock] when called will throw [toThrow].
  static void stubGetSessionsException(MockCourseRepository mock,
      {Exception toThrow =
          const ApiException(prefix: 'ApiException', message: '')}) {
    when(mock.getSessions()).thenAnswer((_) =>
        Future.delayed(const Duration(milliseconds: 50))
            .then((value) => throw toThrow));
  }

  /// Stub the function [getCourses] of [mock] when called will return [toReturn].
  static void stubGetCourses(MockCourseRepository mock,
      {List<Course> toReturn = const [], bool? fromCacheOnly}) {
    when(mock.getCourses(
            fromCacheOnly: fromCacheOnly ?? anyNamed("fromCacheOnly")))
        .thenAnswer((_) async => toReturn);
  }

  /// Stub the function [courses] of [mock] when called will return [toReturn].
  static void stubCourses(MockCourseRepository mock,
      {List<Course> toReturn = const []}) {
    when(mock.courses).thenAnswer((realInvocation) => toReturn);
  }

  /// Stub the function [getCourses] of [mock] when called will throw [toThrow].
  static void stubGetCoursesException(MockCourseRepository mock,
      {Exception toThrow =
          const ApiException(prefix: 'ApiException', message: ''),
      bool? fromCacheOnly}) {
    when(mock.getCourses(
            fromCacheOnly: fromCacheOnly ?? anyNamed("fromCacheOnly")))
        .thenAnswer((_) => Future.delayed(const Duration(milliseconds: 50))
            .then((value) => throw toThrow));
  }

  /// Stub the function [getCourseSummary] of [mock] when called will return [toReturn].
  static void stubGetCourseSummary(
      MockCourseRepository mock, Course courseCalled,
      {Course? toReturn}) {
    when(mock.getCourseSummary(courseCalled)).thenAnswer((_) async => toReturn);
  }

  /// Stub the function [getCourseSummary] of [mock] when called will throw [toThrow].
  static void stubGetCourseSummaryException(
      MockCourseRepository mock, Course courseCalled,
      {Exception toThrow =
          const ApiException(prefix: 'ApiException', message: '')}) {
    when(mock.getCourseSummary(courseCalled)).thenAnswer((_) =>
        Future.delayed(const Duration(milliseconds: 50))
            .then((value) => throw toThrow));
  }
}
