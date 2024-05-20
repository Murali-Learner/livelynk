// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_chat_clone/providers/auth_provider.dart';
import 'package:whatsapp_chat_clone/views/home_page.dart';
import 'package:whatsapp_chat_clone/views/utils/extensions/context_extensions.dart';
import 'package:whatsapp_chat_clone/views/utils/extensions/spacer_extension.dart';
import 'package:whatsapp_chat_clone/views/utils/toast.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:
                  //  (authState == AuthStatus.loading)
                  //     ? const Center(child: CircularProgressIndicator())
                  //     :
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  Consumer<AuthProvider>(builder: (context, provider, _) {
                    return ElevatedButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        String userName = _usernameController.text.trim();
                        String password = _passwordController.text.trim();
                        String email = _emailController.text.trim();

                        if (_formKey.currentState!.validate()) {
                          bool success = await provider.register(
                              userName, email, password);
                          if (success) {
                            context.pushReplacement(
                                navigateTo: const HomePage());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(provider.errorMessage ??
                                      'Unknown error')),
                            );
                          }
                        } else {
                          showErrorToast(
                            message: "Please fill all fields",
                          );
                          return;
                        }
                      },
                      child: const Text('Register'),
                    );
                  }),
                  10.vSpace,
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Already have an account? Log in'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
