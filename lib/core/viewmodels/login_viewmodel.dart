// FLUTTER / DART / THIRD-PARTIES
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// SERVICE
import 'package:notredame/core/managers/user_repository.dart';
import 'package:notredame/core/services/navigation_service.dart';

// OTHER
import 'package:notredame/locator.dart';
import 'package:notredame/core/constants/router_paths.dart';

class LoginViewModel extends BaseViewModel {
  /// Used to authenticate the user
  final UserRepository _userRepository = locator<UserRepository>();

  /// Used to redirect on the dashboard.
  final NavigationService _navigationService = locator<NavigationService>();

  /// Regex matcher to validate the Universal code pattern
  final RegExp _universalCodeMatcher = RegExp(r'[a-zA-Z]{2}\d{5}');

  /// l10n class used to return the right error message
  final AppIntl _appIntl;

  String _universalCode = "";
  String get universalCode => _universalCode;

  String _password = "";
  String get password => _password;

  /// Used to enable/disable the "log in" button
  bool get canSubmit => _universalCode.isNotEmpty && _password.isNotEmpty;

  LoginViewModel({@required AppIntl intl}) : _appIntl = intl;

  /// Validate the format of the universal code
  String validateUniversalCode(String value) {
    if (value.isEmpty) {
      _universalCode = "";
      return _appIntl.login_error_field_required;
    } else if (!_universalCodeMatcher.hasMatch(value)) {
      _universalCode = "";
      return _appIntl.login_error_invalid_universal_code;
    }
    _universalCode = value;
    return null;
  }

  /// Validate there is a password typed
  String validatePassword(String value) {
    if (value.isEmpty) {
      _password = "";
      return _appIntl.login_error_field_required;
    }
    _password = value;
    return null;
  }

  /// Try to authenticate the user. Redirect to the [DashboardView] if everything is correct
  Future<String> authenticate() async {
    if (!canSubmit) {
      return _appIntl.error;
    }

    setBusy(true);
    final response = await _userRepository.authenticate(
        username: _universalCode.toUpperCase(), password: _password);

    if (response) {
      _navigationService.pushNamedAndRemoveUntil(RouterPaths.dashboard);
      return '';
    }

    _password = "";
    setBusy(false);
    notifyListeners();

    return _appIntl.error;
  }
}
