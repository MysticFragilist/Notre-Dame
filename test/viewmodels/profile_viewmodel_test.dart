// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// MANAGERS
import 'package:notredame/core/managers/user_repository.dart';

// VIEW-MODEL
import 'package:notredame/core/viewmodels/profile_viewmodel.dart';

// MODEL
import 'package:notredame/core/models/profile_student.dart';
import 'package:notredame/core/models/program.dart';

import '../helpers.dart';

// MOCKS
import '../mock/managers/settings_manager_mock.dart';
import '../mock/managers/user_repository_mock.dart';
import '../mock/services/networking_service_mock.dart';

late UserRepositoryMock userRepositoryMock;
late SettingsManagerMock settingsManagerMock;
late NetworkingServiceMock networkingServiceMock;
late ProfileViewModel viewModel;

void main() {
  // Needed to support FlutterToast.
  TestWidgetsFlutterBinding.ensureInitialized();
  final Program program1 = Program(
      name: 'program1',
      code: '0000',
      average: '0.00',
      accumulatedCredits: '99',
      registeredCredits: '99',
      completedCourses: '99',
      failedCourses: '0',
      equivalentCourses: '0',
      status: 'Actif');
  final Program program2 = Program(
      name: 'program2',
      code: '0001',
      average: '0.00',
      accumulatedCredits: '99',
      registeredCredits: '99',
      completedCourses: '99',
      failedCourses: '0',
      equivalentCourses: '0',
      status: 'Actif');
  final Program program3 = Program(
      name: 'program3',
      code: '0002',
      average: '0.00',
      accumulatedCredits: '99',
      registeredCredits: '99',
      completedCourses: '99',
      failedCourses: '99',
      equivalentCourses: '99',
      status: 'Actif');

  final List<Program> programs = [program1, program2, program3];

  final ProfileStudent info = ProfileStudent(
      balance: '99.99',
      firstName: 'John',
      lastName: 'Doe',
      permanentCode: 'DOEJ00000000');

  group("ProfileViewModel - ", () {
    setUp(() async {
      // Setting up mocks
      userRepositoryMock = setupUserRepositoryMock() as UserRepositoryMock;
      networkingServiceMock =
          setupNetworkingServiceMock() as NetworkingServiceMock;
      setupFlutterToastMock();

      // Stub to simulate that the user has an active internet connection
      NetworkingServiceMock.stubHasConnectivity(networkingServiceMock);

      viewModel = ProfileViewModel(intl: await setupAppIntl());
    });

    tearDown(() {
      unregister<UserRepository>();
      unregister<NetworkingServiceMock>();
      tearDownFlutterToastMock();
    });

    group("futureToRun - ", () {
      test(
          "first load from cache then call SignetsAPI to get the latest events",
          () async {
        UserRepositoryMock.stubGetInfo(userRepositoryMock);
        UserRepositoryMock.stubGetPrograms(userRepositoryMock);

        expect(await viewModel.futureToRun(), []);

        verifyInOrder([
          userRepositoryMock.getInfo(fromCacheOnly: true),
          userRepositoryMock.getPrograms(fromCacheOnly: true),
          userRepositoryMock.getInfo(),
        ]);

        verifyNoMoreInteractions(userRepositoryMock);
      });

      test("Signets throw an error while trying to get new events", () async {
        UserRepositoryMock.stubGetInfo(userRepositoryMock, fromCacheOnly: true);
        UserRepositoryMock.stubGetInfoException(userRepositoryMock,
            fromCacheOnly: false);
        UserRepositoryMock.stubGetPrograms(userRepositoryMock,
            fromCacheOnly: true);
        UserRepositoryMock.stubGetProgramsException(userRepositoryMock,
            fromCacheOnly: false);

        expect(await viewModel.futureToRun(), [],
            reason: "Even if SignetsAPI fails we should receives a list.");

        verifyInOrder([
          userRepositoryMock.getInfo(fromCacheOnly: true),
          userRepositoryMock.getPrograms(fromCacheOnly: true),
          userRepositoryMock.getInfo(),
        ]);

        verifyNoMoreInteractions(userRepositoryMock);
      });
    });

    group("info - ", () {
      test("build the info", () async {
        UserRepositoryMock.stubProfileStudent(userRepositoryMock,
            toReturn: info);

        expect(viewModel.profileStudent, info);

        verify(userRepositoryMock.info).called(1);

        verifyNoMoreInteractions(userRepositoryMock);
      });
    });

    group("programs - ", () {
      test("build the list of programs", () async {
        UserRepositoryMock.stubPrograms(userRepositoryMock, toReturn: programs);

        expect(viewModel.programList, programs);

        verify(userRepositoryMock.programs).called(2);

        verifyNoMoreInteractions(userRepositoryMock);
      });
    });

    group('refresh -', () {
      test('Call SignetsAPI to get the user info and programs', () async {
        UserRepositoryMock.stubProfileStudent(userRepositoryMock,
            toReturn: info);
        UserRepositoryMock.stubGetInfo(userRepositoryMock, toReturn: info);
        UserRepositoryMock.stubGetPrograms(userRepositoryMock);

        await viewModel.refresh();

        expect(viewModel.profileStudent, info);

        verifyInOrder([
          userRepositoryMock.getInfo(),
          userRepositoryMock.getPrograms(),
          userRepositoryMock.info,
        ]);

        verifyNoMoreInteractions(userRepositoryMock);
      });
    });
  });
}
