part of 'product_cubit.dart';

abstract class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductUpdateState extends ProductState {}

final class ProductAddLoadState extends ProductState {}

final class ProductAddSuccessState extends ProductState {}

final class ProductAddErrorState extends ProductState {
  String error;

  ProductAddErrorState(this.error);
}

final class ProductLoadState extends ProductState {}

final class ProductSuccessState extends ProductState {}

final class ProductErrorState extends ProductState {
  String error;

  ProductErrorState(this.error);
}
