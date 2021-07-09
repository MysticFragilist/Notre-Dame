// FLUTTER / DART / THIRD-PARTIES
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notredame/core/managers/cache_manager.dart';

// SERVICES / MANAGER
import 'package:notredame/core/managers/user_repository.dart';
import 'package:notredame/core/services/analytics_service.dart';
import 'package:notredame/core/services/networking_service.dart';
import 'package:notredame/core/services/signets_api.dart';

// MODELS
import 'package:notredame/core/models/mon_ets_user.dart';
import 'package:notredame/core/models/profile_student.dart';
import 'package:notredame/core/models/program.dart';
import 'package:notredame/core/utils/api_exception.dart';

// HELPERS
import '../defaults.dart';
import '../helpers.dart';

// MOCKS
import '../mock/managers/cache_manager_stub.dart';
import '../mock/services/flutter_secure_storage_stub.dart';
import '../mock/services/mon_ets_api_stub.dart';
import '../mock/services/networking_service_stub.dart';
import '../mock/services/signets_api_stub.dart';
import '../mocks_generators.mocks.dart';

void main() {
  late MockAnalyticsService analyticsServiceMock;
  late MockMonETSApi monETSApiMock;
  late MockFlutterSecureStorage secureStorageMock;
  late MockCacheManager cacheManagerMock;
  late MockSignetsApi signetsApiMock;
  late MockNetworkingService networkingServiceMock;

  late UserRepository manager;

  group('UserRepository - ', () {
    setUp(() {
      // Setup needed service
      analyticsServiceMock = setupAnalyticsServiceMock();
      monETSApiMock = setupMonETSApiMock();
      secureStorageMock = setupFlutterSecureStorageMock();
      cacheManagerMock = setupCacheManagerMock();
      signetsApiMock = setupSignetsApiMock();
      networkingServiceMock = setupNetworkingServiceMock();
      setupLogger();

      manager = UserRepository();
    });

    tearDown(() {
      unregister<AnalyticsService>();
      unregister<MockMonETSApi>();
      unregister<FlutterSecureStorage>();
      clearInteractions(cacheManagerMock);
      unregister<CacheManager>();
      clearInteractions(signetsApiMock);
      unregister<SignetsApi>();
      unregister<NetworkingService>();
    });

    group('authentication - ', () {
      test('right credentials', () async {
        final MonETSUser user = MonETSUser(
            domain: "ENS", typeUsagerId: 1, username: "right credentials");

        MonETSApiStub.stubAuthenticate(monETSApiMock, user);

        // Result is true
        expect(
            await manager.authenticate(username: user.username!, password: ""),
            isTrue,
            reason: "Check the authentication is successful");

        // Verify the secureStorage is used
        verify(secureStorageMock.write(
            key: UserRepository.usernameSecureKey, value: user.username));
        verify(secureStorageMock.write(
            key: UserRepository.passwordSecureKey, value: ""));

        // Verify the user id is set in the analytics
        verify(analyticsServiceMock.setUserProperties(
            userId: user.username, domain: user.domain));

        expect(manager.monETSUser, user,
            reason: "Verify the right user is saved");
      });

      test('An exception is throw during the MonETSApi call', () async {
        const String username = "exceptionUser";
        MonETSApiStub.stubException(monETSApiMock, username);

        expect(await manager.authenticate(username: username, password: ""),
            isFalse,
            reason: "The authentication failed so the result should be false");

        // Verify the user id isn't set in the analytics
        verify(analyticsServiceMock.logError(UserRepository.tag, any))
            .called(1);

        // Verify the secureStorage isn't used
        verifyNever(secureStorageMock.write(
            key: UserRepository.usernameSecureKey, value: username));
        verifyNever(secureStorageMock.write(
            key: UserRepository.passwordSecureKey, value: ""));

        // Verify the user id is set in the analytics
        verifyNever(analyticsServiceMock.setUserProperties(
            userId: username, domain: anyNamed("domain")));

        expect(manager.monETSUser, null,
            reason: "Verify the user stored should be null");
      });
    });

    group('silentAuthenticate - ', () {
      test('credentials are saved so the authentication should be done',
          () async {
        const String username = "username";
        const String password = "password";

        final MonETSUser user =
            MonETSUser(domain: "ENS", typeUsagerId: 1, username: username);

        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.usernameSecureKey, valueToReturn: username);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.passwordSecureKey, valueToReturn: password);

        MonETSApiStub.stubAuthenticate(monETSApiMock, user);

        expect(await manager.silentAuthenticate(), isTrue,
            reason: "Result should be true");

        verifyInOrder([
          secureStorageMock.read(key: UserRepository.usernameSecureKey),
          secureStorageMock.read(key: UserRepository.passwordSecureKey),
          monETSApiMock.authenticate(username: username, password: password),
          analyticsServiceMock.setUserProperties(
              userId: username, domain: user.domain)
        ]);

        expect(manager.monETSUser, user,
            reason: "The authentication succeed so the user should be set");
      });

      test('credentials are saved but the authentication fail', () async {
        const String username = "username";
        const String password = "password";

        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.usernameSecureKey, valueToReturn: username);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.passwordSecureKey, valueToReturn: password);

        MonETSApiStub.stubAuthenticateException(monETSApiMock, username);

        expect(await manager.silentAuthenticate(), isFalse,
            reason: "Result should be false");

        verifyInOrder([
          secureStorageMock.read(key: UserRepository.usernameSecureKey),
          secureStorageMock.read(key: UserRepository.passwordSecureKey),
          monETSApiMock.authenticate(username: username, password: password),
          analyticsServiceMock.logError(UserRepository.tag, any)
        ]);

        expect(manager.monETSUser, null,
            reason: "The authentication failed so the user should be null");
      });

      test('credentials are not saved so the authentication should not be done',
          () async {
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.usernameSecureKey, valueToReturn: null);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.passwordSecureKey, valueToReturn: null);

        expect(await manager.silentAuthenticate(), isFalse,
            reason: "Result should be false");

        verifyInOrder(
            [secureStorageMock.read(key: UserRepository.usernameSecureKey)]);

        verifyNoMoreInteractions(secureStorageMock);
        verifyZeroInteractions(monETSApiMock);
        verifyZeroInteractions(analyticsServiceMock);

        expect(manager.monETSUser, null,
            reason:
                "The authentication didn't happened so the user should be null");
      });
    });

    group('logOut - ', () {
      test('the user credentials are deleted', () async {
        expect(await manager.logOut(), isTrue);

        expect(manager.monETSUser, null,
            reason: "The user shouldn't be available after a logout");

        verify(secureStorageMock.delete(key: UserRepository.usernameSecureKey));
        verify(secureStorageMock.delete(key: UserRepository.passwordSecureKey));

        verifyNever(analyticsServiceMock.logError(UserRepository.tag, any));
      });
    });

    group('getPassword - ', () {
      tearDown(() async {
        await manager.logOut();
      });

      test('the user is authenticated so the password should be returned.',
          () async {
        const String username = "username";
        const String password = "password";

        final MonETSUser user =
            MonETSUser(domain: "ENS", typeUsagerId: 1, username: username);

        MonETSApiStub.stubAuthenticate(monETSApiMock, user);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.usernameSecureKey, valueToReturn: username);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.passwordSecureKey, valueToReturn: password);

        expect(await manager.silentAuthenticate(), isTrue);

        expect(await manager.getPassword(), password,
            reason: "Result should be 'password'");

        verifyInOrder([
          secureStorageMock.read(key: UserRepository.usernameSecureKey),
          secureStorageMock.read(key: UserRepository.passwordSecureKey),
          monETSApiMock.authenticate(username: username, password: password),
          analyticsServiceMock.setUserProperties(
              userId: username, domain: user.domain)
        ]);
      });

      test(
          'the user is not authenticated and silent authentication is available, so the user should authenticate.',
          () async {
        const String username = "username";
        const String password = "password";

        final MonETSUser user =
            MonETSUser(domain: "ENS", typeUsagerId: 1, username: username);

        MonETSApiStub.stubAuthenticate(monETSApiMock, user);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.usernameSecureKey, valueToReturn: username);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.passwordSecureKey, valueToReturn: password);

        expect(await manager.getPassword(), password,
            reason: "Result should be 'password'");

        verifyInOrder([
          analyticsServiceMock.logEvent(UserRepository.tag, any),
          secureStorageMock.read(key: UserRepository.usernameSecureKey),
          secureStorageMock.read(key: UserRepository.passwordSecureKey),
          monETSApiMock.authenticate(username: username, password: password),
          analyticsServiceMock.setUserProperties(
              userId: username, domain: user.domain)
        ]);
      });

      test(
          'the user is not authenticated and silent authentication is available but fail, an ApiException should be thrown.',
          () async {
        const String username = "username";
        const String password = "password";

        MonETSApiStub.stubAuthenticateException(monETSApiMock, username);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.usernameSecureKey, valueToReturn: username);
        FlutterSecureStorageStub.stubRead(secureStorageMock,
            key: UserRepository.passwordSecureKey, valueToReturn: password);

        expect(manager.getPassword(), throwsA(isInstanceOf<ApiException>()),
            reason:
                'The authentication failed so an ApiException should be raised.');

        await untilCalled(
            analyticsServiceMock.logError(UserRepository.tag, any));

        verify(analyticsServiceMock.logError(UserRepository.tag, any))
            .called(1);
      });
    });

    group("getPrograms - ", () {
      final List<Program> programs = [
        Program(
            name: 'Genie',
            code: '9999',
            average: '3',
            accumulatedCredits: '3',
            registeredCredits: '4',
            completedCourses: '6',
            failedCourses: '5',
            equivalentCourses: '7',
            status: 'Actif')
      ];

      const String username = "username";

      final MonETSUser user =
          MonETSUser(domain: "ENS", typeUsagerId: 1, username: username);

      setUp(() async {
        // Stub to simulate presence of programs cache
        CacheManagerStub.stubGet(cacheManagerMock,
            UserRepository.programsCacheKey, jsonEncode(programs));

        MonETSApiStub.stubAuthenticate(monETSApiMock, user);

        // Result is true
        expect(
            await manager.authenticate(username: user.username!, password: ""),
            isTrue,
            reason: "Check the authentication is successful");

        // Stub SignetsApi answer to test only the cache retrieving
        SignetsApiStub.stubGetPrograms(signetsApiMock, username, []);

        // Stub to simulate that the user has an active internet connection
        NetworkingServiceStub.stubHasConnectivity(networkingServiceMock);
      });

      test("Programs are loaded from cache", () async {
        expect(manager.programs, isNull);
        final results = await manager.getPrograms();

        expect(results, isInstanceOf<List<Program>>());
        expect(results, programs);
        expect(manager.programs, programs,
            reason: 'The programs list should now be loaded.');

        verify(cacheManagerMock.get(UserRepository.programsCacheKey));
        verify(manager.getPassword());
        verify(cacheManagerMock.update(
            UserRepository.programsCacheKey, jsonEncode(programs)));
      });

      test("Trying to load programs from cache but cache doesn't exist",
          () async {
        // Stub to simulate an exception when trying to get the programs from the cache
        reset(cacheManagerMock);
        CacheManagerStub.stubGetException(
            cacheManagerMock, UserRepository.programsCacheKey);

        expect(manager.programs, isNull);
        final results = await manager.getPrograms();

        expect(results, isInstanceOf<List<Program>>());
        expect(results, []);
        expect(manager.programs, []);

        verify(cacheManagerMock.get(UserRepository.programsCacheKey));
        verify(manager.getPassword());
        verifyNever(cacheManagerMock.update(
            UserRepository.programsCacheKey, jsonEncode(programs)));
      });

      test("SignetsAPI return another program", () async {
        // Stub to simulate presence of program cache
        reset(cacheManagerMock);
        CacheManagerStub.stubGet(
            cacheManagerMock, UserRepository.programsCacheKey, jsonEncode([]));

        // Stub SignetsApi answer to test only the cache retrieving
        reset(signetsApiMock);
        SignetsApiStub.stubGetPrograms(signetsApiMock, username, programs);

        expect(manager.programs, isNull);
        final results = await manager.getPrograms();

        expect(results, isInstanceOf<List<Program>>());
        expect(results, programs);
        expect(manager.programs, programs,
            reason: 'The programs list should now be loaded.');

        verify(cacheManagerMock.get(UserRepository.programsCacheKey));
        verify(manager.getPassword());
        verify(cacheManagerMock.update(
            UserRepository.programsCacheKey, jsonEncode(programs)));
      });

      test("SignetsAPI return a program that already exists", () async {
        // Stub SignetsApi answer to test only the cache retrieving
        reset(signetsApiMock);
        SignetsApiStub.stubGetPrograms(signetsApiMock, username, programs);

        expect(manager.programs, isNull);
        final results = await manager.getPrograms();

        expect(results, isInstanceOf<List<Program>>());
        expect(results, programs);
        expect(manager.programs, programs,
            reason: 'The programs list should not have any duplicata..');

        verify(cacheManagerMock.get(UserRepository.programsCacheKey));
        verify(manager.getPassword());
        verify(cacheManagerMock.update(
            UserRepository.programsCacheKey, jsonEncode(programs)));
      });

      test("SignetsAPI return an exception", () async {
        // Stub to simulate presence of program cache
        reset(cacheManagerMock);
        CacheManagerStub.stubGet(
            cacheManagerMock, UserRepository.programsCacheKey, jsonEncode([]));

        // Stub SignetsApi answer to test only the cache retrieving
        SignetsApiStub.stubGetProgramsException(signetsApiMock, username);

        expect(manager.programs, isNull);
        expect(manager.getPrograms(), throwsA(isInstanceOf<ApiException>()));

        await untilCalled(networkingServiceMock.hasConnectivity());
        expect(manager.programs, [],
            reason: 'The programs list should be empty');

        await untilCalled(
            analyticsServiceMock.logError(UserRepository.tag, any));

        verify(cacheManagerMock.get(UserRepository.programsCacheKey));
        verify(manager.getPassword());
        verify(analyticsServiceMock.logError(UserRepository.tag, any));

        verifyNever(
            cacheManagerMock.update(UserRepository.programsCacheKey, any));
      });

      test("Cache update fail", () async {
        // Stub to simulate presence of program cache
        reset(cacheManagerMock);
        CacheManagerStub.stubGet(
            cacheManagerMock, UserRepository.programsCacheKey, jsonEncode([]));

        // Stub to simulate exception when updating cache
        CacheManagerStub.stubUpdateException(
            cacheManagerMock, UserRepository.programsCacheKey);

        // Stub SignetsApi answer to test only the cache retrieving
        SignetsApiStub.stubGetPrograms(signetsApiMock, username, programs);

        expect(manager.programs, isNull);
        final results = await manager.getPrograms();

        expect(results, isInstanceOf<List<Program>>());
        expect(results, programs);
        expect(manager.programs, programs,
            reason:
                'The programs list should now be loaded even if the caching fails.');
      });

      test("Should force fromCacheOnly mode when user has no connectivity",
          () async {
        //Stub the networkingService to return no connectivity
        reset(networkingServiceMock);
        NetworkingServiceStub.stubHasConnectivity(networkingServiceMock,
            hasConnectivity: false);

        final programsCache = await manager.getPrograms();
        expect(programsCache, programs);
      });
    });

    group("getInfo - ", () {
      final ProfileStudent info = ProfileStudent(
          balance: '99.99',
          firstName: 'John',
          lastName: 'Doe',
          permanentCode: 'DOEJ00000000');

      const String username = "username";

      final MonETSUser user =
          MonETSUser(domain: "ENS", typeUsagerId: 1, username: username);

      setUp(() async {
        // Stub to simulate presence of info cache
        CacheManagerStub.stubGet(
            cacheManagerMock, UserRepository.infoCacheKey, jsonEncode(info));

        MonETSApiStub.stubAuthenticate(monETSApiMock, user);

        // Result is true
        expect(
            await manager.authenticate(username: user.username!, password: ""),
            isTrue,
            reason: "Check the authentication is successful");

        // Stub SignetsApi answer to test only the cache retrieving
        SignetsApiStub.stubGetInfo(
            signetsApiMock, username, defaultProfileStudent);

        // Stub to simulate that the user has an active internet connection
        NetworkingServiceStub.stubHasConnectivity(networkingServiceMock);
      });

      test("Info are loaded from cache", () async {
        expect(manager.info, isNull);
        final results = await manager.getInfo();

        expect(results, isInstanceOf<ProfileStudent>());
        expect(results, info);
        expect(manager.info, info, reason: 'The info should now be loaded.');

        verify(cacheManagerMock.get(UserRepository.infoCacheKey));
        verify(manager.getPassword());
        verify(cacheManagerMock.update(
            UserRepository.infoCacheKey, jsonEncode(info)));
      });

      test("Trying to load info from cache but cache doesn't exist", () async {
        // Stub to simulate an exception when trying to get the info from the cache
        reset(cacheManagerMock);
        CacheManagerStub.stubGetException(
            cacheManagerMock, UserRepository.infoCacheKey);

        expect(manager.info, isNull);
        final results = await manager.getInfo();

        expect(results, isNull);
        expect(manager.info, isNull);

        verify(cacheManagerMock.get(UserRepository.infoCacheKey));
        verify(manager.getPassword());
        verifyNever(cacheManagerMock.update(
            UserRepository.infoCacheKey, jsonEncode(info)));
      });

      test("SignetsAPI return another info", () async {
        // Stub to simulate presence of info cache
        reset(cacheManagerMock);
        CacheManagerStub.stubGet(
            cacheManagerMock, UserRepository.infoCacheKey, jsonEncode(info));

        // Stub SignetsApi answer to test only the cache retrieving
        final ProfileStudent anotherInfo = ProfileStudent(
            balance: '0.0',
            firstName: 'Johnny',
            lastName: 'Doe',
            permanentCode: 'DOEJ00000000');
        reset(signetsApiMock);
        SignetsApiStub.stubGetInfo(signetsApiMock, username, anotherInfo);

        expect(manager.info, isNull);
        final results = await manager.getInfo();

        expect(results, isInstanceOf<ProfileStudent>());
        expect(results, info);
        expect(manager.info, info, reason: 'The info should now be loaded.');

        verify(cacheManagerMock.get(UserRepository.infoCacheKey));
        verify(manager.getPassword());
        verify(cacheManagerMock.update(
            UserRepository.infoCacheKey, jsonEncode(info)));
      });

      test("SignetsAPI return a info that already exists", () async {
        // Stub SignetsApi answer to test only the cache retrieving
        reset(signetsApiMock);
        SignetsApiStub.stubGetInfo(signetsApiMock, username, info);

        expect(manager.info, isNull);
        final results = await manager.getInfo();

        expect(results, isInstanceOf<ProfileStudent>());
        expect(results, info);
        expect(manager.info, info,
            reason: 'The info should not have any duplicata..');

        verify(cacheManagerMock.get(UserRepository.infoCacheKey));
        verify(manager.getPassword());
        verifyNever(cacheManagerMock.update(
            UserRepository.infoCacheKey, jsonEncode(info)));
      });

      test("SignetsAPI return an exception", () async {
        // Stub to simulate presence of info cache
        reset(cacheManagerMock);
        CacheManagerStub.stubGet(
            cacheManagerMock, UserRepository.infoCacheKey, jsonEncode(info));

        // Stub SignetsApi answer to test only the cache retrieving
        SignetsApiStub.stubGetInfoException(signetsApiMock, username);

        expect(manager.info, isNull);
        expect(manager.getInfo(), throwsA(isInstanceOf<ApiException>()));
        expect(manager.info, null, reason: 'The info should be empty');

        await untilCalled(
            analyticsServiceMock.logError(UserRepository.tag, any));

        verify(cacheManagerMock.get(UserRepository.infoCacheKey));
        verify(manager.getPassword());
        verify(analyticsServiceMock.logError(UserRepository.tag, any));

        verifyNever(cacheManagerMock.update(UserRepository.infoCacheKey, any));
      });

      test("Cache update fail", () async {
        // Stub to simulate presence of session cache
        reset(cacheManagerMock);
        CacheManagerStub.stubGet(
            cacheManagerMock, UserRepository.infoCacheKey, jsonEncode(info));

        // Stub to simulate exception when updating cache
        CacheManagerStub.stubUpdateException(
            cacheManagerMock, UserRepository.infoCacheKey);

        // Stub SignetsApi answer to test only the cache retrieving
        SignetsApiStub.stubGetInfo(signetsApiMock, username, info);

        expect(manager.info, isNull);
        final results = await manager.getInfo();

        expect(results, isInstanceOf<ProfileStudent>());
        expect(results, info);
        expect(manager.info, info,
            reason: 'The info should now be loaded even if the caching fails.');
      });

      test("Should force fromCacheOnly mode when user has no connectivity",
          () async {
        //Stub the networkingService to return no connectivity
        reset(networkingServiceMock);
        NetworkingServiceStub.stubHasConnectivity(networkingServiceMock,
            hasConnectivity: false);

        final infoCache = await manager.getInfo();
        expect(infoCache, info);
      });
    });
  });
}
