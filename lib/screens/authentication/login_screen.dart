import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/bloc/authBloc/auth_cubit.dart';
import 'package:paw_pal_admin/core/AppColors.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';

import '../../utils/widget_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: mainView());
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            commonTextFieldWithLabel(
              label: "Email",
              hint: "Enter your email",
              context: context,
              controller: emailController,
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: isPasswordVisible,
              builder: (context, value, child) {
                return commonTextFieldWithLabel(
                  label: "Password",
                  hint: "Enter your password",
                  context: context,
                  obscureText: !value,
                  controller: passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(value ? Icons.visibility : Icons.visibility_off,color: AppColors.primaryColor,),
                    onPressed: () {
                      isPasswordVisible.value = !value;
                    },
                  ),
                  textInputAction: TextInputAction.done,
                );
              },
            ),

            const SizedBox(height: 30),
            btnLogin(),
          ],
        ),
      ),
    );
  }

  Widget btnLogin() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;
        return commonButtonView(
          context: context,
          buttonText: "Login",
          isLoading: isLoading,
          onClicked: () {
            final email = emailController.text.trim();
            final password = passwordController.text.trim();
            if (email.isEmpty) {
              CommonMethods().showErrorToast("enter email");
              return;
            } else if (password.isEmpty) {
              CommonMethods().showErrorToast("enter password");
              return;
            } else {
              context.read<AuthCubit>().login(
                context: context,
                email: email,
                password: password,
              );
            }
          },
        );
      },
    );
  }
}
