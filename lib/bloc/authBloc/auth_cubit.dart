import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/routes/routes.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  FirebaseAuth auth = FirebaseAuth.instance;

  void login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    emit(AuthLoadingState());

    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      CommonMethods().showSuccessToast("Login Successful");

      if (!context.mounted) return;
      context.goNamed(Routes.dashBoardScreen);

      emit(AuthSuccessState());

    } on FirebaseAuthException catch (e) {

      String errorMessage = CommonMethods.getFirebaseAuthErrorMessage(e);


       CommonMethods().showErrorToast(errorMessage);
      emit(AuthErrorState(errorMessage));

    } catch (e) {
      emit(AuthErrorState("Something went wrong. Please try again."));
    }
  }

}
