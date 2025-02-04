// FLUTTER / DART / THIRD-PARTIES
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// MANAGERS
import 'package:notredame/core/managers/user_repository.dart';

// MODELS
import 'package:notredame/core/models/profile_student.dart';
import 'package:notredame/core/models/program.dart';

// OTHERS
import '../../locator.dart';

class ProfileViewModel extends FutureViewModel<List<Program>> {
  /// Load the user
  final UserRepository _userRepository = locator<UserRepository>();

  /// Localization class of the application.
  final AppIntl _appIntl;

  /// List of the programs
  List<Program> _programList = List.empty();

  /// Student's profile
  final ProfileStudent _student = ProfileStudent(
      balance: "", firstName: "", lastName: "", permanentCode: "");

  /// Return the profileStudent
  ProfileStudent get profileStudent {
    return _userRepository.info ?? _student;
  }

  /// Return the universal access code of the student
  String get universalAccessCode =>
      _userRepository?.monETSUser?.universalCode ?? '';

  ProfileViewModel({@required AppIntl intl}) : _appIntl = intl;

  @override
  // ignore: type_annotate_public_apis
  void onError(error) {
    Fluttertoast.showToast(msg: _appIntl.error);
  }

  /// Return the list of programs for the student
  List<Program> get programList {
    if (_programList == null || _programList.isEmpty) {
      _programList = [];
    }
    if (_userRepository.programs != null) {
      _programList = _userRepository.programs;
    }
    return _programList;
  }

  bool isLoadingEvents = false;

  @override
  Future<List<Program>> futureToRun() => _userRepository
          .getInfo(fromCacheOnly: true)
          .then((value) => _userRepository.getPrograms(fromCacheOnly: true))
          .then((value) {
        setBusyForObject(isLoadingEvents, true);
        _userRepository
            .getInfo()
            // ignore: return_type_invalid_for_catch_error
            .catchError(onError)
            // ignore: return_type_invalid_for_catch_error
            .then((value) => _userRepository.getPrograms().catchError(onError))
            .whenComplete(() {
          setBusyForObject(isLoadingEvents, false);
        });
        return value;
      });

  Future refresh() async {
    try {
      setBusyForObject(isLoadingEvents, true);
      _userRepository
          .getInfo()
          .then((value) => _userRepository.getPrograms().then((value) {
                setBusyForObject(isLoadingEvents, false);
                notifyListeners();
              }));
    } on Exception catch (error) {
      onError(error);
    }
  }
}
