import 'package:chat_app/pages/pages.dart';
import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Center(
              child: LinearProgressIndicator(
                color: Colors.green,
                backgroundColor: Colors.transparent,
              ),
            ),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authServices = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authServices.isLoggedIn();
    if (autenticado) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsersPage(),
          transitionDuration: Duration(seconds: 2),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          transitionDuration: Duration(seconds: 2),
        ),
      );
    }
  }
}
