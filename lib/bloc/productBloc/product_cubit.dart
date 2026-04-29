import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/core/constant.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';

import '../../model/product_category_model.dart';
import '../../model/product_model.dart';
import '../../services/firestore_service.dart';
import '../../services/image_upload_service.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FirebaseServices services;

  ProductCubit(this.services) : super(ProductInitial());

  final ImageUploadService imageService = ImageUploadService();
  final fireStore = FireStoreService().fireStore;

  ProductCategoryModel? selectedCategory;
  int? selectedCategoryIndex;

  ProductCategoryModel? filterCategory;
  int? filterCategoryIndex;
  bool isAllFilterSelected = true;

  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productVariantController = TextEditingController();
  TextEditingController productVariantPriceController = TextEditingController();
  TextEditingController productBasePriceController = TextEditingController();

  final ValueNotifier<File?> productMainImageNotifier = ValueNotifier(null);
  final ValueNotifier<File?> productOtherImage1Notifier = ValueNotifier(null);
  final ValueNotifier<File?> productOtherImage2Notifier = ValueNotifier(null);
  final ValueNotifier<File?> productOtherImage3Notifier = ValueNotifier(null);
  final ValueNotifier<File?> productOtherImage4Notifier = ValueNotifier(null);

  List<ProductVariant> lstProductVariant = [];
  List<ProductModel> lstProduct = [];

  void getSelectedCategory(ProductCategoryModel category) {
    selectedCategory = category;
    emit(ProductUpdateState());
  }

  void setCategoryIndex(int index) {
    selectedCategoryIndex = index;
    emit(ProductUpdateState());
  }

  void selectAllFilter() {
    filterCategory = null;
    filterCategoryIndex = 0;
    isAllFilterSelected = true;
    emit(ProductUpdateState());
  }

  void selectFilterCategory(ProductCategoryModel category, int index) {
    filterCategory = category;
    filterCategoryIndex = index;
    isAllFilterSelected = false;
    emit(ProductUpdateState());
  }

  List<ProductModel> get filteredProducts {
    if (isAllFilterSelected || filterCategory == null) {
      return lstProduct;
    }

    return lstProduct
        .where((product) => product.categoryName == filterCategory?.categoryName)
        .toList();
  }

  void addVariant() {
    lstProductVariant.add(
      ProductVariant(
        title: productVariantController.text.trim(),
        price:
            double.tryParse(productVariantPriceController.text.trim()) ?? 0.0,
      ),
    );
    emit(ProductUpdateState());
  }

  void removeVariant(int index) {
    lstProductVariant.removeAt(index);
    emit(ProductUpdateState());
  }

  void createProduct(BuildContext context) async {
    emit(ProductAddLoadState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;
      final productMainImage = await imageService.uploadImage(
        image: productMainImageNotifier.value,
        uid: user.uid,
      );
      List<String> otherProductImageUrls = [];
      final images = [
        productOtherImage1Notifier.value,
        productOtherImage2Notifier.value,
        productOtherImage3Notifier.value,
        productOtherImage4Notifier.value,
      ];
      for (var image in images) {
        if (image != null) {
          final url = await imageService.uploadImage(
            image: image,
            uid: user.uid,
          );
          if (url != null) {
            otherProductImageUrls.add(url);
          }
        }
      }

      final productId = fireStore.collection("products").doc().id;

      ProductModel productModel = ProductModel(
        id: productId,
        name: productNameController.text.trim(),
        description: productDescriptionController.text.trim(),
        categoryId: selectedCategory?.id ?? "",
        categoryName: selectedCategory?.categoryName ?? "",
        mainProductImage: productMainImage ?? "",
        images: otherProductImageUrls,
        isActive: true,
        basePrice: selectedCategory?.variantType == VariantType.none
            ? double.tryParse(productBasePriceController.text.trim()) ?? 0
            : 0,
        rating: "",
        variants: selectedCategory?.variantType == VariantType.none
            ? []
            : lstProductVariant,
        variantType: selectedCategory?.variantType ?? VariantType.none,
        createdAt: DateTime.now(),
      );
      await services.createProduct(productModel);
      if (!context.mounted) return;
      CommonMethods().showSuccessToast("Product Create Successfully");
      context.pop();
      emit(ProductAddSuccessState());
    } catch (e) {
      CommonMethods().showErrorToast(e.toString());
      emit(ProductAddErrorState(e.toString()));
    }
  }

  Future<void> getProducts() async {
    emit(ProductLoadState());
    try {
      lstProduct = await services.getProducts();
      emit(ProductSuccessState());
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  Future<void> updateAvailabilityOfProduct(
      int index,
      bool value,
      String id,
      ) async {
    try {
      lstProduct[index].isActive = value;
      emit(ProductSuccessState());
      await services.updateAvailabilityOfProduct(
        id: id,
        object: {"isActive": value},
      );
    } catch (e) {
      lstProduct[index].isActive = !value;
      CommonMethods().showErrorToast(e.toString());
      emit(ProductSuccessState());
    }
  }

  void resetLocalData() {
    selectedCategoryIndex = null;
    selectedCategory = null;
    productBasePriceController.clear();
    productDescriptionController.clear();
    productMainImageNotifier.value = null;
    productNameController.clear();
    productVariantPriceController.clear();
    productVariantController.clear();
    productOtherImage1Notifier.value = null;
    productOtherImage2Notifier.value = null;
    productOtherImage3Notifier.value = null;
    productOtherImage4Notifier.value = null;
    lstProductVariant = [];
    emit(ProductInitial());
  }

  double getProductPrice(ProductModel model) {
    if (model.variants.isNotEmpty) {
     return model.variants.first.price;
    }
    return model.basePrice;
  }

  String? getProductSize(ProductModel model) {
    return model.variants.first.title;
  }
}
