// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/mockito.dart';

// MANAGER
import 'package:notredame/core/managers/course_repository.dart';

// MODELS
import 'package:notredame/core/models/course_activity.dart';
import 'package:notredame/core/models/session.dart';
import 'package:notredame/core/models/course.dart';

// EXCEPTIONS
import 'package:notredame/core/utils/api_exception.dart';

class CourseRepositoryMock extends Mock implements CourseRepository {
  @override
  Future<List<CourseActivity>?> getCoursesActivities(
          {bool? fromCacheOnly = false}) async =>
      super.noSuchMethod(
          Invocation.method(#getCoursesActivities, [], {
            #fromCacheOnly: fromCacheOnly,
          }),
          returnValue: Future<List<CourseActivity>?>.value(
              List<CourseActivity>.from([]))) as Future<List<CourseActivity>?>;

  @override
  Future<List<Course>?> getCourses({bool? fromCacheOnly = false}) async =>
      super.noSuchMethod(
          Invocation.method(#getCoursesActivities, [], {
            #fromCacheOnly: fromCacheOnly,
          }),
          returnValue: Future<List<Course>?>.value()) as Future<List<Course>?>;

  @override
  Future<Course?> getCourseSummary(Course? course) async =>
      super.noSuchMethod(Invocation.method(#getCourseSummary, [course]),
          returnValue: Future<Course?>.value()) as Future<Course?>;

  @override
  List<Session>? get sessions =>
      super.noSuchMethod(Invocation.getter(#sessions),
          returnValue: List<Session>.from([])) as List<Session>?;

  @override
  Future<List<Session>?> getSessions() async =>
      super.noSuchMethod(Invocation.method(#getSessions, []),
              returnValue: Future<List<Session>?>.value(List<Session>.from([])))
          as Future<List<Session>?>;

  @override
  List<CourseActivity>? get coursesActivities =>
      super.noSuchMethod(Invocation.getter(#coursesActivities),
          returnValue: List<CourseActivity>.from([])) as List<CourseActivity>?;

  /// Stub the getter [coursesActivities] of [mock] when called will return [toReturn].
  static void stubCoursesActivities(CourseRepositoryMock mock,
      {List<CourseActivity> toReturn = const []}) {
    when(mock.coursesActivities).thenReturn(toReturn);
  }

  /// Stub the getter [sessions] of [mock] when called will return [toReturn].
  static void stubSessions(CourseRepositoryMock mock,
      {List<Session> toReturn = const []}) {
    when(mock.sessions).thenReturn(toReturn);
  }

  /// Stub the getter [activeSessions] of [mock] when called will return [toReturn].
  static void stubActiveSessions(CourseRepositoryMock mock,
      {List<Session> toReturn = const []}) {
    when(mock.activeSessions).thenReturn(toReturn);
  }

  /// Stub the function [getCoursesActivities] of [mock] when called will return [toReturn].
  static void stubGetCoursesActivities(CourseRepositoryMock mock,
      {List<CourseActivity> toReturn = const [], bool? fromCacheOnly}) {
    when(mock.getCoursesActivities(
            fromCacheOnly: fromCacheOnly ?? anyNamed("fromCacheOnly")))
        .thenAnswer((_) async => toReturn);
  }

  /// Stub the function [getCoursesActivities] of [mock] when called will throw [toThrow].
  static void stubGetCoursesActivitiesException(CourseRepositoryMock mock,
      {Exception toThrow =
          const ApiException(prefix: 'ApiException', message: ''),
      bool? fromCacheOnly}) {
    when(mock.getCoursesActivities(
            fromCacheOnly: fromCacheOnly ?? anyNamed("fromCacheOnly")))
        .thenAnswer((_) => Future.delayed(const Duration(milliseconds: 50))
            .then((value) => throw toThrow));
  }

  /// Stub the function [getSessions] of [mock] when called will return [toReturn].
  static void stubGetSessions(CourseRepositoryMock mock,
      {List<Session> toReturn = const []}) {
    when(mock.getSessions()).thenAnswer((_) async => toReturn);
  }

  /// Stub the function [getSessions] of [mock] when called will throw [toThrow].
  static void stubGetSessionsException(CourseRepositoryMock mock,
      {Exception toThrow =
          const ApiException(prefix: 'ApiException', message: '')}) {
    when(mock.getSessions()).thenAnswer((_) =>
        Future.delayed(const Duration(milliseconds: 50))
            .then((value) => throw toThrow));
  }

  /// Stub the function [getCourses] of [mock] when called will return [toReturn].
  static void stubGetCourses(CourseRepositoryMock mock,
      {List<Course> toReturn = const [], bool? fromCacheOnly}) {
    when(mock.getCourses(
            fromCacheOnly: fromCacheOnly ?? anyNamed("fromCacheOnly")))
        .thenAnswer((_) async => toReturn);
  }

  /// Stub the function [courses] of [mock] when called will return [toReturn].
  static void stubCourses(CourseRepositoryMock mock,
      {List<Course> toReturn = const []}) {
    when(mock.courses).thenAnswer((realInvocation) => toReturn);
  }

  /// Stub the function [getCourses] of [mock] when called will throw [toThrow].
  static void stubGetCoursesException(CourseRepositoryMock mock,
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
      CourseRepositoryMock mock, Course courseCalled,
      {Course? toReturn}) {
    when(mock.getCourseSummary(courseCalled)).thenAnswer((_) async => toReturn);
  }

  /// Stub the function [getCourseSummary] of [mock] when called will throw [toThrow].
  static void stubGetCourseSummaryException(
      CourseRepositoryMock mock, Course courseCalled,
      {Exception toThrow =
          const ApiException(prefix: 'ApiException', message: '')}) {
    when(mock.getCourseSummary(courseCalled)).thenAnswer((_) =>
        Future.delayed(const Duration(milliseconds: 50))
            .then((value) => throw toThrow));
  }
}
