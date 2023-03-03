import 'package:chat_app/helpers/helpers.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
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
                  const CustomLogo(titulo: 'Messenger'),
                  _Form(),
                  const CustomLabels(
                    ruta: 'register',
                    label1: '¿No Tienes Cuenta?',
                    label2: 'Crear Una Ahora!',
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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
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
            text: "Ingresar",
            onPressed: authService.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());
                    if (loginOk) {
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      mostrarAlerta(
                        context,
                        "Login Incorrecto",
                        'Introduce las credenciales Correctas',
                      );
                    }
                  },
          )
        ],
      ),
    );
  }
}
