import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/model/product_category_model.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';
import 'package:paw_pal_admin/services/firestore_service.dart';

import '../../core/CommonMethods.dart';
import '../../core/constant.dart';
import '../../services/image_upload_service.dart';

part 'product_category_state.dart';

class ProductCategoryCubit extends Cubit<ProductCategoryState> {
  final FirebaseServices services;

  ProductCategoryCubit(this.services) : super(ProductCategoryInitial());
  final fireStore = FireStoreService().fireStore;
  TextEditingController categoryNameController = TextEditingController();

  ValueNotifier<File?> categoryImageNotifier = ValueNotifier(null);

  VariantType selectedVariantType = VariantType.none;
  final ImageUploadService imageService = ImageUploadService();
  List<ProductCategoryModel> lstCategory = [];

  void updateVariantType(VariantType type) {
    selectedVariantType = type;
    emit(ProductCategoryUpdatedState());
  }

  void createCategory(BuildContext context) async {
    emit(UploadCategoryLoadingState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;
      final categoryImage = await imageService.uploadImage(
        image: categoryImageNotifier.value,
        uid: user.uid,
      );
      String id = fireStore.collection("product_category").doc().id;
      ProductCategoryModel model = ProductCategoryModel(
        id: id,
        image: categoryImage ?? "",
        categoryName: categoryNameController.text.trim(),
        variantType: selectedVariantType,
        createdAt: DateTime.now(),
      );
      await services.createProductCategory(model);
      await getProductCategory();
      if (!context.mounted) return;
      CommonMethods().showSuccessToast("Category Create Successfully");
      context.pop();
      emit(UploadCategorySuccessState());
    } catch (e) {
      CommonMethods().showErrorToast(e.toString());
      emit(UploadCategoryErrorState(e.toString()));
    }
  }

  void resetLocalData() {
    categoryNameController.clear();
    categoryImageNotifier.value = null;
    selectedVariantType = VariantType.none;
  }

  bool isValidCategory() {
    if (categoryImageNotifier.value == null) {
      CommonMethods().showErrorToast("Please upload category image");
      return false;
    }
    if (categoryNameController.text.trim().isEmpty) {
      CommonMethods().showErrorToast("Please enter category name");
      return false;
    }
    return true;
   }

  Future<void> getProductCategory() async {
    emit(FetchCategoryLoadingState());
    try {
      lstCategory = await services.getProductCategory();
      emit(FetchCategorySuccessState());
    } catch (e) {
      emit(FetchCategoryErrorState(e.toString()));
    }
  }
}
