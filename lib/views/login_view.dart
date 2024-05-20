// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/views/home_page.dart';
import 'package:livelynk/views/register_view.dart';
import 'package:livelynk/views/utils/extensions/context_extensions.dart';
import 'package:livelynk/views/utils/extensions/spacer_extension.dart';
import 'package:livelynk/views/utils/toast.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
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

                        if (_formKey.currentState!.validate()) {
                          bool success =
                              await provider.login(userName, password);
                          if (success) {
                            context.pushReplacement(
                                navigateTo: const HomePage());
                          } else {
                            showErrorToast(
                                message:
                                    provider.errorMessage ?? 'Unknown error');
                          }
                        } else {
                          showErrorToast(
                            message: "Please fill all fields",
                          );
                          return;
                        }
                      },
                      child: const Text('Login'),
                    );
                  }),
                  10.vSpace,
                  TextButton(
                    onPressed: () {
                      context.pushReplacement(navigateTo: RegisterPage());
                    },
                    child: const Text('Create an account'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
