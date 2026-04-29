import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/model/pet_category_model.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';

import '../../services/firestore_service.dart';

part 'pet_category_state.dart';

class PetCategoryCubit extends Cubit<PetCategoryState> {
  FirebaseServices services;

  PetCategoryCubit(this.services) : super(PetCategoryInitial());
  final fireStore = FireStoreService().fireStore;
  TextEditingController categoryController = TextEditingController();
  List<PetCategoryModel> lstPetCategory = [];

  void createPetCategory(BuildContext context) async {
    emit(AddPetLoadState());
    try {
      String id = fireStore.collection("pet_category").doc().id;
      PetCategoryModel pet = PetCategoryModel(
        id: id,
        categoryName: categoryController.text.trim(),
        createdAt: DateTime.now(),
      );

      await services.createPetCategory(pet);
      await getPetCategory();
      CommonMethods().showSuccessToast("Pet Category Create SuccessFully");
      if (!context.mounted) return;
      context.pop();
      emit(AddPetSuccessState());
    } catch (e) {
      emit(AddPetErrorState(e.toString()));
    }
  }

  Future<void> getPetCategory() async {
    emit(lstPetCategory.isNotEmpty ? PetCategoryRefreshState() : PetCategoryLoadState());
    try {
      lstPetCategory = await services.getPetCategory();
      emit(PetCategorySuccessState());
    } catch (e) {
      emit(PetCategoryErrorState(e.toString()));
    }
  }

  void reset() {
    categoryController.clear();
    emit(PetCategoryInitial());
  }
}
