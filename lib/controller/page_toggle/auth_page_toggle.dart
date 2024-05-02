import 'package:lamie/constants/enumes.dart';

class AuthPageToggleController {
  AuthPageMode _mode = AuthPageMode.login;
  void toggleAuthPage() {
    _mode == AuthPageMode.login
        ? _mode = AuthPageMode.signup
        : AuthPageMode.login;
  }

  AuthPageMode get currentMode {
    return _mode;
  }
}
