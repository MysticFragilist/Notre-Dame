// FLUTTER / DART / THIRD-PARTIES
import 'package:mockito/mockito.dart';
import 'package:notredame/core/managers/course_repository.dart';

// MODELS
import 'package:notredame/core/models/course_activity.dart';
import 'package:notredame/core/models/course_summary.dart';
import 'package:notredame/core/models/profile_student.dart';
import 'package:notredame/core/models/program.dart';
import 'package:notredame/core/models/session.dart';
import 'package:notredame/core/models/course.dart';

// SERVICE
import 'package:notredame/core/services/signets_api.dart';
import 'package:notredame/core/utils/api_exception.dart';

// UTILS
import '../../mocks_generators.mocks.dart';

/// Mock for the [SignetsApi]
class SignetsApiStub {
  /// Stub the answer of the [getCoursesActivities] when the [session] is used.
  static void stubGetCoursesActivities(MockSignetsApi mock, String session,
      List<CourseActivity> coursesActivitiesToReturn) {
    when(mock.getCoursesActivities(
            username: anyNamed("username"),
            password: anyNamed("password"),
            session: session))
        .thenAnswer((_) async => coursesActivitiesToReturn);
  }

  /// Throw [exceptionToThrow] when [getCoursesActivities] with the [session] is used.
  static void stubGetCoursesActivitiesException(
      MockSignetsApi mock, String session,
      {ApiException exceptionToThrow =
          const ApiException(prefix: CourseRepository.tag, message: "")}) {
    when(mock.getCoursesActivities(
            username: anyNamed("username"),
            password: anyNamed("password"),
            session: session))
        .thenThrow(exceptionToThrow);
  }

  /// Stub the answer of the [getSessions] when the [username] is used.
  static void stubGetSessions(
      MockSignetsApi mock, String username, List<Session> sessionsToReturn) {
    when(mock.getSessions(username: username, password: anyNamed("password")))
        .thenAnswer((_) async => sessionsToReturn);
  }

  /// Throw [exceptionToThrow] when [getSessions] with the [username] is used.
  static void stubGetSessionsException(MockSignetsApi mock, String username,
      {ApiException exceptionToThrow =
          const ApiException(prefix: SignetsApi.tag, message: "")}) {
    when(mock.getSessions(username: username, password: anyNamed("password")))
        .thenThrow(exceptionToThrow);
  }

  /// Stub the answer of the [getPrograms] when the [username] is used.
  static void stubGetPrograms(
      MockSignetsApi mock, String username, List<Program> programsToReturn) {
    when(mock.getPrograms(username: username, password: anyNamed("password")))
        .thenAnswer((_) async => programsToReturn);
  }

  /// Throw [exceptionToThrow] when [getPrograms] with the [username] is used.
  static void stubGetProgramsException(MockSignetsApi mock, String username,
      {ApiException exceptionToThrow =
          const ApiException(prefix: SignetsApi.tag, message: "")}) {
    when(mock.getPrograms(username: username, password: anyNamed("password")))
        .thenThrow(exceptionToThrow);
  }

  /// Stub the answer of the [getInfo] when the [username] is used.
  static void stubGetInfo(
      MockSignetsApi mock, String username, ProfileStudent infoToReturn) {
    when(mock.getStudentInfo(
            username: username, password: anyNamed("password")))
        .thenAnswer((_) async => infoToReturn);
  }

  /// Throw [exceptionToThrow] when [getInfo] with the [username] is used.
  static void stubGetInfoException(MockSignetsApi mock, String username,
      {ApiException exceptionToThrow =
          const ApiException(prefix: SignetsApi.tag, message: "")}) {
    when(mock.getStudentInfo(
            username: username, password: anyNamed("password")))
        .thenThrow(exceptionToThrow);
  }

  /// Stub the answer of the [getCourses] when the [username] is used.
  static void stubGetCourses(MockSignetsApi mock, String username,
      {List<Course> coursesToReturn = const []}) {
    when(mock.getCourses(username: username, password: anyNamed("password")))
        .thenAnswer((_) async => coursesToReturn);
  }

  /// Throw [exceptionToThrow] when [getCourses] with the [username] is used.
  static void stubGetCoursesException(MockSignetsApi mock, String username,
      {ApiException exceptionToThrow =
          const ApiException(prefix: SignetsApi.tag, message: "")}) {
    when(mock.getCourses(username: username, password: anyNamed("password")))
        .thenThrow(exceptionToThrow);
  }

  /// Stub the answer of the [getCourseSummary] when the [username] and [course] is used.
  static void stubGetCourseSummary(
      MockSignetsApi mock, String username, Course? course,
      {required CourseSummary summaryToReturn}) {
    when(mock.getCourseSummary(
            username: username, course: course, password: anyNamed("password")))
        .thenAnswer((_) async => summaryToReturn);
  }

  /// Throw [exceptionToThrow] when [getCourseSummary] with the [username] and [course] is used.
  static void stubGetCourseSummaryException(
      MockSignetsApi mock, String username, Course? course,
      {ApiException exceptionToThrow =
          const ApiException(prefix: SignetsApi.tag, message: "")}) {
    when(mock.getCourseSummary(
            username: username, course: course, password: anyNamed("password")))
        .thenThrow(exceptionToThrow);
  }
}
