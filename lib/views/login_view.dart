// ignore_for_file: always_specify_types

import 'package:dotenv/dotenv.dart';
import 'package:flutter/material.dart';
import 'package:quarkus_api_front/controllers/authentication.dart';
import 'package:quarkus_api_front/views/car_list_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var env = DotEnv(includePlatformEnvironment: true)..load();
  Authentication authentication = Authentication();

  String? username;
  String? password;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onSaved: (newValue) => username = newValue,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obrigatório' : null,
                      decoration: const InputDecoration(labelText: 'Usuário'),
                    ),
                    TextFormField(
                      obscureText: true,
                      onSaved: (newValue) => password = newValue,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obrigatório' : null,
                      decoration: const InputDecoration(labelText: 'Senha'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          bool authenticated = await authentication.getToken(
                            username: username!,
                            password: password!,
                          );

                          if (authenticated) {
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (ctx) => const CarListView(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Usuário ou senha inválidos.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Entrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
