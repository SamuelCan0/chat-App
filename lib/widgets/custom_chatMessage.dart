import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomChatMessage extends StatelessWidget {
  const CustomChatMessage({
    super.key,
    required this.message,
    required this.uid,
    required this.animationController,
  });

  final String message;
  final String uid;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child:
              uid == authService.usuario.uid ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.greenAccent[400],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5, right: 50, left: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(message, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
