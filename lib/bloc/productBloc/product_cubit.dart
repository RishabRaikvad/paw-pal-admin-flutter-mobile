import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:paw_pal_admin/model/product_category_model.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';

import '../../model/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FirebaseServices services;

  ProductCubit(this.services) : super(ProductInitial());

  ProductCategoryModel? selectedCategory;
  int? selectedCategoryIndex;

  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productVariantController = TextEditingController();
  TextEditingController productVariantPriceController = TextEditingController();

  final ValueNotifier<File?> productMainImageNotifier = ValueNotifier(null);
  final ValueNotifier<File?> productOtherImage1Notifier = ValueNotifier(null);
  final ValueNotifier<File?> productOtherImage2Notifier = ValueNotifier(null);
  final ValueNotifier<File?> productOtherImage3Notifier = ValueNotifier(null);
  final ValueNotifier<File?> productOtherImage4Notifier = ValueNotifier(null);
  List<ProductVariant> lstProductVariant = [];

  void getSelectedCategory(ProductCategoryModel category) {
    selectedCategory = category;
    emit(ProductUpdateState());
  }

  void setCategoryIndex(int index) {
    selectedCategoryIndex = index;
    emit(ProductUpdateState());
  }

  void resetLocalData() {
    selectedCategoryIndex = null;
    selectedCategory = null;
    emit(ProductInitial());
  }

  void addVariant() {
    lstProductVariant.add(
      ProductVariant(
        title: productVariantController.text.trim(),
        price: double.tryParse(productVariantPriceController.text.trim()) ?? 0.0,
      ),
    );
    emit(ProductUpdateState());
  }

  void removeVariant(int index) {
    lstProductVariant.removeAt(index);
    emit(ProductUpdateState());
  }
}
