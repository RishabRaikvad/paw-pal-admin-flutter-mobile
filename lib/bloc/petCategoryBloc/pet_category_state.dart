part of 'pet_category_cubit.dart';

abstract class PetCategoryState {}

final class PetCategoryInitial extends PetCategoryState {}

final class AddPetLoadState extends PetCategoryState {}

final class AddPetSuccessState extends PetCategoryState {}

final class AddPetErrorState extends PetCategoryState {
  final String error;

  AddPetErrorState(this.error);
}
