import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/bloc/authBloc/auth_cubit.dart';
import 'package:paw_pal_admin/core/AppColors.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';

import '../../core/AppImages.dart';
import '../../core/AppStrings.dart';
import '../../core/constant.dart';
import '../../utils/ui_helper.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.imgLoginBg,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: UIHelper.screenHeight(context) * 0.018,
            child: mainView(),
          ),
        ],
      ),
    );
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            welcomeTitle(),
            const SizedBox(height: 3),
            welcomeSubTitle(),
            const SizedBox(height: 4),
            commonTextFieldWithLabel(
              label: AppStrings.email,
              hint: AppStrings.enterEmailAddress,
              context: context,
              controller: emailController,
              inputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: isPasswordVisible,
              builder: (context, value, child) {
                return commonTextFieldWithLabel(
                  label: AppStrings.password,
                  hint: AppStrings.enterPassword,
                  context: context,
                  obscureText: !value,
                  controller: passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      value ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.primaryColor,
                    ),
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

  Widget welcomeTitle() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: AppStrings.welcome,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontFamily: Constant.fontFamily,
            ),
          ),
          TextSpan(
            text: '${AppStrings.to} ',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              fontFamily: Constant.fontFamily,
            ),
          ),
          TextSpan(
            text: AppStrings.paw,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
              fontFamily: Constant.fontFamily,
            ),
          ),
          TextSpan(
            text: AppStrings.pal,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              fontFamily: Constant.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget welcomeSubTitle() {
    return commonTitle(
      title: AppStrings.loginSubtitle,
      fontSize: 14,
      textAlign: TextAlign.start,
      color: AppColors.grey,
    );
  }

  Widget btnLogin() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;
        return commonButtonView(
          context: context,
          buttonText: AppStrings.accessDashBoard,
          isLoading: isLoading,
          onClicked: () {
            final email = emailController.text.trim();
            final password = passwordController.text.trim();
            if (email.isEmpty) {
              CommonMethods().showErrorToast(AppStrings.pleaseEnterEmail);
              return;
            } else if (!emailRegex.hasMatch(email)) {
              CommonMethods().showErrorToast(AppStrings.emailError);
              return;
            } else if (password.isEmpty) {
              CommonMethods().showErrorToast(AppStrings.pleaseEnterPassword);
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
