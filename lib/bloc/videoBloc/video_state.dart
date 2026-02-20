part of 'video_cubit.dart';

abstract class VideoState {}

final class VideoInitial extends VideoState {}

final class VideoAddSuccessState extends VideoState {}

final class VideoAddLoadingState extends VideoState {}

final class VideoAddErrorState extends VideoState {
  final String error;

  VideoAddErrorState(this.error);
}
