part of 'faq_cubit.dart';

abstract class FaqState {}

final class FaqInitial extends FaqState {}

final class FaqLoadState extends FaqState {}

final class FaqRefreshState extends FaqState {}

final class FaqSuccessState extends FaqState {}

final class FaqErrorState extends FaqState {
  final String error;

  FaqErrorState(this.error);
}

final class AddFaqLoadState extends FaqState {}

final class AddFaqSuccessState extends FaqState {}

final class AddFaqErrorState extends FaqState {
  final String error;

  AddFaqErrorState(this.error);
}
