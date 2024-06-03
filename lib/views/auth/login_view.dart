// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:livelynk/views/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:livelynk/providers/auth_provider.dart';
import 'package:livelynk/views/home_page.dart';
import 'package:livelynk/views/auth/register_view.dart';
import 'package:livelynk/utils/extensions/context_extensions.dart';
import 'package:livelynk/utils/extensions/spacer_extension.dart';
import 'package:livelynk/utils/toast.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
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
              child: Column(
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
                  Consumer<AuthProvider>(builder: (context, provider, _) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: provider.obscureText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password must be at least 8 characters long';
                        } else {
                          return null;
                        }
                      },
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
                              String email = _emailController.text.trim();
                              String password = _passwordController.text.trim();

                              if (_formKey.currentState!.validate()) {
                                bool success =
                                    await provider.login(email, password);
                                if (success) {
                                  context.pushReplacement(
                                    navigateTo: const HomePage(),
                                  );
                                } else {
                                  showErrorToast(
                                      message: provider.errorMessage ??
                                          'Unknown error');
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
                      context.push(navigateTo: RegisterPage());
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
