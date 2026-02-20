import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:go_router/go_router.dart';
import '../../core/AppImages.dart';
import '../../routes/routes.dart';
import '../../utils/commonWidget/gradient_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateInScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: RepaintBoundary(child: SvgPicture.asset(AppImages.icSplash)),
        ),
      ),
    );
  }

  void navigateInScreen() async {
    final user = CommonMethods.getCurrentUser();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (user == null) {
      context.goNamed(Routes.loginScreen);
    } else {
      context.goNamed(Routes.dashBoardScreen);
    }
  }
}
