part of 'product_category_cubit.dart';

abstract class ProductCategoryState {}

final class ProductCategoryInitial extends ProductCategoryState {}

final class ProductCategoryUpdatedState extends ProductCategoryState {}

final class UploadCategoryLoadingState extends ProductCategoryState {}

final class UploadCategorySuccessState extends ProductCategoryState {}

final class UploadCategoryErrorState extends ProductCategoryState {
  final String message;

  UploadCategoryErrorState(this.message);
}

final class FetchCategoryLoadingState extends ProductCategoryState {}

final class FetchCategorySuccessState extends ProductCategoryState {
  FetchCategorySuccessState();
}

final class FetchCategoryErrorState extends ProductCategoryState {
  final String message;

  FetchCategoryErrorState(this.message);
}
