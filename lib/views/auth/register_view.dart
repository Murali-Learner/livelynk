// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:livelynk/views/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/views/home_page.dart';
import 'package:livelynk/utils/extensions/context_extensions.dart';
import 'package:livelynk/utils/extensions/spacer_extension.dart';

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
          automaticallyImplyLeading: false,
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
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value!.isEmpty || value.length <= 2) {
                        return 'Username must be at least 3 characters long';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  Consumer<AuthProvider>(builder: (context, provider, _) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: provider.obscureText,
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 7) {
                          return 'Password must be at least 8 characters long';
                        } else {
                          return null;
                        }
                      },
                      maxLength: 8,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              provider.togglePassword();
                            },
                            icon: !provider.obscureText
                                ? const Icon(Icons.visibility_off_outlined)
                                : const Icon(Icons.visibility_outlined)),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Consumer<AuthProvider>(builder: (context, provider, _) {
                    return provider.isLoading
                        ? const LoadingWidget()
                        : ElevatedButton(
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
