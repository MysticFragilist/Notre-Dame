import 'package:notredame/core/models/course_summary.dart';
import 'package:notredame/core/models/evaluation.dart';
import 'package:notredame/core/models/mon_ets_user.dart';
import 'package:notredame/core/models/profile_student.dart';

Evaluation get defaultEvaluation => Evaluation(
    courseGroup: "courseGroup",
    title: "title",
    weight: 0.0,
    published: true,
    teacherMessage: "teacherMessage",
    ignore: false,
    correctedEvaluationOutOf: "correctedEvaluationOutOf");

CourseSummary get defaultCourseSummary => CourseSummary(
    currentMark: 0.0,
    currentMarkInPercent: 0.0,
    markOutOf: 0.0,
    passMark: 0.0,
    standardDeviation: 0.0,
    median: 0.0,
    percentileRank: 0,
    evaluations: []);

ProfileStudent get defaultProfileStudent => ProfileStudent(
    balance: "",
    firstName: "firstName",
    lastName: "lastName",
    permanentCode: "permanentCode");

MonETSUser get defaultMonETSUser =>
    MonETSUser(domain: "domain", typeUsagerId: 0, username: "username");
