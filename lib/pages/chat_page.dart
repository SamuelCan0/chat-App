import 'dart:io';

import 'package:chat_app/models/models.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isTyping = false;
  final List<CustomChatMessage> _messages = [];

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(chatService.usuarioPara.uid);
    super.initState();
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map(
      (m) => CustomChatMessage(
        message: m.mensaje,
        uid: m.de,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 0),
        )..forward(),
      ),
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    CustomChatMessage message = CustomChatMessage(
      message: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final chatServices = Provider.of<ChatService>(context);
    final usuarioPara = chatServices.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[200],
              maxRadius: 15,
              child: Text(usuarioPara.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            Text(
              usuarioPara.nombre,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
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
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = CustomChatMessage(
      message: mensaje,
      uid: authService.usuario.uid,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() => _isTyping = false);

    socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': mensaje,
    });
  }

  @override
  void dispose() {
    // TODO: off de sockets

    for (CustomChatMessage message in _messages) {
      message.animationController.dispose();
    }

    socketService.socket.off('mensaje-personal');

    super.dispose();
  }
}
