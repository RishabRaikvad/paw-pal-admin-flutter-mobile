part of 'pet_category_cubit.dart';

abstract class PetCategoryState {}

final class PetCategoryInitial extends PetCategoryState {}

final class AddPetLoadState extends PetCategoryState {}

final class AddPetSuccessState extends PetCategoryState {}

final class AddPetErrorState extends PetCategoryState {
  final String error;

  AddPetErrorState(this.error);
}

final class PetCategoryLoadState extends PetCategoryState {}

final class PetCategoryRefreshState extends PetCategoryState {}

final class PetCategorySuccessState extends PetCategoryState {}

final class PetCategoryErrorState extends PetCategoryState {
  final String error;

  PetCategoryErrorState(this.error);
}
