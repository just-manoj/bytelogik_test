import 'package:flutter/material.dart';

import 'views/login_screen.dart';
import 'views/signup_screen.dart';
import 'views/main_screen.dart';

class Routes {
  static const String login = '/';
  static const String signup = '/signup';
  static const String main = '/main';

  static final Map<String, WidgetBuilder> all = {
    login: (c) => const LoginScreen(),
    signup: (c) => const SignUpScreen(),
    main: (c) => const MainScreen(),
  };
}
