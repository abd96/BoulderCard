import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'database.dart';

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    debugPrint(' authUser Name: ${data.name}, Password: ${data.password}');

    final user = ParseUser.createUser(data.name, data.password, data.name);
    var response = await user.login();
    return Future.delayed(loginTime).then((_) {
      if (!response.success || response.error != null) {
        return response.error!.message;
      }
    });
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');

    // create Parse User Object
    final user = ParseUser.createUser(data.name, data.password, data.name);
    var response = await user.signUp();

    return Future.delayed(loginTime).then((_) {
      if (!response.success || response.error != null) {
        return response.error!.message;
      }
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) async {
      final user = ParseUser.createUser(name, '', name);
      final ParseResponse parseResponse = await user.requestPasswordReset();
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Boulder Cards',
      //logo: AssetImage('assets/images/ecorp-lightblue.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: Icons.android,
          label: 'Google',
          callback: () async {
            debugPrint('start google sign in');
            await Future.delayed(loginTime);
            debugPrint('stop google sign in');
            return null;
          },
        ),
        LoginProvider(
          icon: Icons.facebook,
          label: 'Facebook',
          callback: () async {
            debugPrint('start facebook sign in');
            await Future.delayed(loginTime);
            debugPrint('stop facebook sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              DefaultTabController(length: 2, child: HomePage()),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
