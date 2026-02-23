import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/model/faq_model.dart';
import 'package:paw_pal_admin/progress_loader_screen.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';
import 'package:paw_pal_admin/services/firestore_service.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  final FirebaseServices services;
  final fireStore = FireStoreService().fireStore;

  FaqCubit(this.services) : super(FaqInitial());

  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  List<FaqModel> lstFaq = [];

  Future<void> getFaqs() async {
    emit(lstFaq.isEmpty ? FaqLoadState() : FaqRefreshState());
    try {
      final snapshot = await fireStore.collection("faq's").get();
      lstFaq = snapshot.docs
          .map((doc) => FaqModel.fromJson(doc.data()))
          .toList();
      emit(FaqSuccessState());
    } catch (e) {
      emit(FaqErrorState(e.toString()));
    }
  }

  void createFaq(BuildContext context) async {
    emit(AddFaqLoadState());
    try {
      String id = fireStore.collection("faq's").doc().id;
      FaqModel faq = FaqModel(
        id: id,
        question: questionController.text.trim(),
        answer: answerController.text.trim(),
        createdAt: DateTime.now(),
      );
      await services.createFaq(faq);
      await getFaqs();
      if (!context.mounted) return;
      context.pop();
      emit(AddFaqSuccessState());
    } catch (e) {
      emit(AddFaqErrorState(e.toString()));
    }
  }

  void deleteFaq(String id, BuildContext context) async {
    LoadingDialog.show(context);
    try {
      await services.deleteFaq(id);
      await getFaqs();
      if (!context.mounted) return;
      context.pop();
      CommonMethods().showSuccessToast("Faq Delete SuccessFully");
    } catch (e) {
      CommonMethods().showErrorToast(e.toString());
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }

  void updateFaq({required BuildContext context, required String id}) async {
    LoadingDialog.show(context);
    try {
      Map<String, dynamic> object = {
        "question": questionController.text.trim(),
        "answer": answerController.text.trim(),
      };
      await services.updateFaq(object: object, id: id);
      await getFaqs();
      if (!context.mounted) return;
      context.pop();
      resetLocalData();
    } catch (e) {
      CommonMethods().showErrorToast(e.toString());
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }

  void resetLocalData() {
    questionController.clear();
    answerController.clear();
  }
}
