// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// MANAGERS
import 'package:notredame/core/managers/user_repository.dart';
import 'package:notredame/core/services/networking_service.dart';
import 'package:notredame/core/managers/settings_manager.dart';

// VIEW-MODEL
import 'package:notredame/core/viewmodels/profile_viewmodel.dart';

// MODEL
import 'package:notredame/core/models/profile_student.dart';
import 'package:notredame/core/models/program.dart';

import '../helpers.dart';

// MOCKS
import '../mock/managers/settings_manager_stub.dart';
import '../mock/managers/user_repository_stub.dart';
import '../mock/services/networking_service_stub.dart';

late UserRepositoryStub userRepositoryMock;
late SettingsManagerStub settingsManagerMock;
late NetworkingServiceStub networkingServiceMock;
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
      userRepositoryMock = setupUserRepositoryMock();
      networkingServiceMock = setupNetworkingServiceMock();
      setupFlutterToastMock();

      // Stub to simulate that the user has an active internet connection
      NetworkingServiceStub.stubHasConnectivity(networkingServiceMock);

      viewModel = ProfileViewModel(intl: await setupAppIntl());
    });

    tearDown(() {
      unregister<UserRepository>();
      unregister<NetworkingService>();
      unregister<SettingsManager>();
      tearDownFlutterToastMock();
    });

    group("futureToRun - ", () {
      test(
          "first load from cache then call SignetsAPI to get the latest events",
          () async {
        UserRepositoryStub.stubGetInfo(userRepositoryMock);
        UserRepositoryStub.stubGetPrograms(userRepositoryMock);

        expect(await viewModel.futureToRun(), []);

        verifyInOrder([
          userRepositoryMock.getInfo(fromCacheOnly: true),
          userRepositoryMock.getPrograms(fromCacheOnly: true),
          userRepositoryMock.getInfo(),
        ]);

        verifyNoMoreInteractions(userRepositoryMock);
      });

      test("Signets throw an error while trying to get new events", () async {
        UserRepositoryStub.stubGetInfo(userRepositoryMock, fromCacheOnly: true);
        UserRepositoryStub.stubGetInfoException(userRepositoryMock,
            fromCacheOnly: false);
        UserRepositoryStub.stubGetPrograms(userRepositoryMock,
            fromCacheOnly: true);
        UserRepositoryStub.stubGetProgramsException(userRepositoryMock,
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
        UserRepositoryStub.stubProfileStudent(userRepositoryMock,
            toReturn: info);

        expect(viewModel.profileStudent, info);

        verify(userRepositoryMock.info).called(1);

        verifyNoMoreInteractions(userRepositoryMock);
      });
    });

    group("programs - ", () {
      test("build the list of programs", () async {
        UserRepositoryStub.stubPrograms(userRepositoryMock, toReturn: programs);

        expect(viewModel.programList, programs);

        verify(userRepositoryMock.programs).called(2);

        verifyNoMoreInteractions(userRepositoryMock);
      });
    });

    group('refresh -', () {
      test('Call SignetsAPI to get the user info and programs', () async {
        UserRepositoryStub.stubProfileStudent(userRepositoryMock,
            toReturn: info);
        UserRepositoryStub.stubGetInfo(userRepositoryMock, toReturn: info);
        UserRepositoryStub.stubGetPrograms(userRepositoryMock);

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
