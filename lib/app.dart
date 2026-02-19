
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  firebaseCrashlytics();
  return const PawPalAdminApp();
}
void firebaseCrashlytics() {
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
}
class PawPalAdminApp extends StatefulWidget {
  const PawPalAdminApp({super.key});

  @override
  State<PawPalAdminApp> createState() => _PawPalAppAdminState();
}

class _PawPalAppAdminState extends State<PawPalAdminApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        // BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        // BlocProvider<DashboardCubit>(create: (context) => DashboardCubit()),
        // BlocProvider<MyAccountCubit>(create: (context) => MyAccountCubit()),
        // BlocProvider<PetCubit>(create: (context) => PetCubit()),
        // BlocProvider<HomeCubit>(
        //   create: (context) => HomeCubit(petCubit: context.read<PetCubit>()),
        // ),
        // BlocProvider<ManagePawCubit>(create: (context) => ManagePawCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        // showPerformanceOverlay: true,
        // title: AppStrings.appName,
        // routeInformationProvider: AppRoutes.router.routeInformationProvider,
        // routeInformationParser: AppRoutes.router.routeInformationParser,
        // routerDelegate: AppRoutes.router.routerDelegate,
        // theme: AppTheme.lightThem(),
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);

          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: mediaQuery.textScaler.clamp(
                minScaleFactor: 1.0,
                maxScaleFactor: 1.12,
              ),
              // textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}