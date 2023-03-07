import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 221, 221, 221),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomLogo(titulo: 'Registro'),
                  _Form(),
                  const CustomLabels(
                    ruta: 'login',
                    label1: '¿Ya Tienes Una Cuenta?',
                    label2: 'Ingresa Ahora!',
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Terminos Y Condiciones de Uso',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({
    Key? key,
  }) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.person_outline,
            placeHolder: 'Nombre',
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.email_outlined,
            placeHolder: 'Email',
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.password_outlined,
            placeHolder: 'Password',
            textController: passCtrl,
            isPassword: true,
          ),
          CustomBtn(
            text: "Registrar",
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final registroOk = await authService.register(
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                      nameCtrl.text.trim(),
                    );
                    if (registroOk == true) {
                      socketService.connectar();
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      if (registroOk == null) {
                        mostrarAlerta(
                          context,
                          "Registro Incorrecto",
                          'Campos Vacios',
                        );
                      } else {
                        mostrarAlerta(
                          context,
                          "Registro Incorrecto",
                          '$registroOk',
                        );
                      }
                    }
                  },
          )
        ],
      ),
    );
  }
}
