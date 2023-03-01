import 'dart:io';

import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isTyping = false;
  List<CustomChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('TE', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.green[200],
              maxRadius: 15,
            ),
            const SizedBox(height: 3),
            Text(
              'Teodoro',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int i) => _messages[i],
              ),
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                keyboardType: TextInputType.url,
                onChanged: (message) {
                  setState(() {
                    if (message.trim().isNotEmpty) {
                      _isTyping = true;
                    } else {
                      _isTyping = false;
                    }
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Escribir Mensaje...'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: const Text("Enviar"),
                      onPressed: _isTyping
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.green[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: _isTyping
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                          icon: Icon(Icons.send_sharp),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String mensaje) {
    print(mensaje);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = CustomChatMessage(
      message: mensaje,
      uid: '123',
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() => _isTyping = false);
  }

  @override
  void dispose() {
    // TODO: off de sockets

    for (CustomChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}
