import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/routes/routes.dart';
import 'package:paw_pal_admin/screens/authentication/login_screen.dart';
import 'package:paw_pal_admin/screens/dashboard/dashboard_screen.dart';
import 'package:paw_pal_admin/screens/faq/create_faq.dart';
import 'package:paw_pal_admin/screens/faq/faq_screen.dart';
import 'package:paw_pal_admin/screens/videoManageMent/add_video_screen.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/videoManageMent/video_screen.dart';

class AppRoutes {
  static final GoRouter _router = GoRouter(
    initialLocation: Routes.rootNamePath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.rootNamePath,
        name: Routes.rootName,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: Routes.loginScreenPath,
        name: Routes.loginScreen,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: Routes.dashBoardScreenPath,
        name: Routes.dashBoardScreen,
        builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(
        path: Routes.addVideoScreenPath,
        name: Routes.addVideoScreen,
        builder: (context, state) => AddVideoScreen(),
      ),
      GoRoute(
        path: Routes.videoScreenPath,
        name: Routes.videoScreen,
        builder: (context, state) => VideoScreen(),
      ),
      GoRoute(
        path: Routes.faqScreenPath,
        name: Routes.faqScreen,
        builder: (context, state) => FaqScreen(),
      ),
      GoRoute(
        path: Routes.createFaqScreenPath,
        name: Routes.createFaqScreen,
        builder: (context, state) => CreateFaq(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
