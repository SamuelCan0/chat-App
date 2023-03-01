import 'package:chat_app/pages/pages.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => UsersPage(),
  'login': (_) => LoginPage(),
  'loading': (_) => LoadingPage(),
  'register': (_) => RegisterPage(),
  'chat': (_) => ChatPage(),
};
