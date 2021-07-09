// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// CONSTANTS
import 'package:notredame/core/constants/preferences_flags.dart';
import 'package:notredame/core/constants/router_paths.dart';

// SERVICES / MANAGERS
import 'package:notredame/core/managers/user_repository.dart';
import 'package:notredame/core/services/navigation_service.dart';
import 'package:notredame/core/managers/settings_manager.dart';

// VIEW MODEL
import 'package:notredame/core/viewmodels/startup_viewmodel.dart';

// OTHER
import '../helpers.dart';
import '../mock/managers/settings_manager_stub.dart';
import '../mock/managers/user_repository_stub.dart';
import '../mock/services/networking_service_stub.dart';

void main() {
  late NavigationService navigationService;
  late UserRepositoryStub userRepositoryMock;
  late SettingsManagerStub settingsManagerMock;
  late NetworkingServiceStub networkingService;

  late StartUpViewModel viewModel;

  group('StartupViewModel - ', () {
    setUp(() async {
      navigationService = setupNavigationServiceMock();
      settingsManagerMock = setupSettingsManagerMock();
      userRepositoryMock = setupUserRepositoryMock();
      networkingService = setupNetworkingServiceMock();

      setupLogger();

      viewModel = StartUpViewModel();
    });

    tearDown(() {
      unregister<NavigationService>();
      unregister<UserRepository>();
      unregister<SettingsManager>();
    });

    group('handleStartUp - ', () {
      test('sign in successful', () async {
        UserRepositoryStub.stubSilentAuthenticate(userRepositoryMock);
        UserRepositoryStub.stubWasPreviouslyLoggedIn(userRepositoryMock);
        NetworkingServiceStub.stubHasConnectivity(networkingService);

        await viewModel.handleStartUp();

        verify(navigationService.pushNamed(RouterPaths.dashboard));
      });

      test(
          'sign in failed redirect to login if Discovery already been completed',
          () async {
        UserRepositoryStub.stubSilentAuthenticate(userRepositoryMock,
            toReturn: false);
        UserRepositoryStub.stubWasPreviouslyLoggedIn(userRepositoryMock);
        NetworkingServiceStub.stubHasConnectivity(networkingService);

        SettingsManagerStub.stubGetString(
            settingsManagerMock, PreferencesFlag.discovery,
            toReturn: 'true');

        SettingsManagerStub.stubGetString(
            settingsManagerMock, PreferencesFlag.languageChoice,
            toReturn: 'true');

        await viewModel.handleStartUp();

        verify(navigationService.pushNamed(RouterPaths.login));
      });

      test(
          'sign in failed redirect to Choose Language page if Discovery has not been completed',
          () async {
        UserRepositoryStub.stubSilentAuthenticate(userRepositoryMock,
            toReturn: false);
        UserRepositoryStub.stubWasPreviouslyLoggedIn(userRepositoryMock);
        NetworkingServiceStub.stubHasConnectivity(networkingService);

        await viewModel.handleStartUp();

        verify(navigationService.pushNamed(RouterPaths.chooseLanguage));
        verify(settingsManagerMock.setString(
            PreferencesFlag.languageChoice, 'true'));
      });
    });
  });
}
