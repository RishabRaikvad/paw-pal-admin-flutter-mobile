import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/model/video_model.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';
import 'package:paw_pal_admin/services/firestore_service.dart';

import '../../services/image_upload_service.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  FirebaseServices services;
  final ImageUploadService imageService = ImageUploadService();
  final fireStore = FireStoreService().fireStore;

  VideoCubit(this.services) : super(VideoInitial());
  final TextEditingController videoTitleController = TextEditingController();
  final TextEditingController videoTimeController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();

  final ValueNotifier<File?> thumbnailNotifier = ValueNotifier(null);
  final ValueNotifier<File?> ownerImageNotifier = ValueNotifier(null);
  List<VideoModel> lstPetCareVideo = [];
  Map<String, ValueNotifier<bool>> isVisibleUserStatus = {};

  void uploadPetCareVideo(BuildContext context) async {
    emit(VideoAddLoadingState());
    try {
      final user = CommonMethods.getCurrentUser();
      if (user == null) return;
      final thumbnailImage = await imageService.uploadImage(
        image: thumbnailNotifier.value,
        uid: user.uid,
      );
      final ownerImage = await imageService.uploadImage(
        image: ownerImageNotifier.value,
        uid: user.uid,
      );
      String videoId = fireStore.collection("pet_care_videos").doc().id;
      VideoModel videoModel = VideoModel(
        id: videoId,
        thumbnail: thumbnailImage ?? "",
        videoTitle: videoTitleController.text.trim(),
        videoTime: videoTimeController.text.trim(),
        ownerImage: ownerImage ?? "",
        ownerName: ownerNameController.text.trim(),
        videoUrl: videoUrlController.text.trim(),
        isVisible: true,
      );
      await services.createPetCareVideo(videoModel);
      await getPetCareVideos();
      CommonMethods().showSuccessToast("Video Uploaded SuccessFully");
      if (!context.mounted) return;
      context.pop();
      emit(VideoAddSuccessState());
    } catch (e) {
      emit(VideoAddErrorState(e.toString()));
    }
  }

  Future<void> getPetCareVideos() async {
    emit(lstPetCareVideo.isEmpty ? VideoLoadingState() : VideoRefreshState());
    try {
      final snapshot = await fireStore.collection("pet_care_videos").get();
      lstPetCareVideo = snapshot.docs
          .map((doc) => VideoModel.fromJson(doc.data()))
          .toList();
      for (var video in lstPetCareVideo) {
        final notifier = isVisibleUserStatus.putIfAbsent(
          video.id,
          () => ValueNotifier<bool>(video.isVisible),
        );
        notifier.value = video.isVisible;
      }
      emit(VideoSuccessState());
    } catch (e) {
      emit(VideoErrorState(e.toString()));
    }
  }

  Future<void> toggleVisibleStatus(
      String videoId,
      bool newValue,
      ) async {
    final notifier = isVisibleUserStatus[videoId];
    if (notifier == null) return;

    final old = notifier.value;
    notifier.value = newValue;

    try {
      await fireStore
          .collection("pet_care_videos")
          .doc(videoId)
          .update({"isVisible": newValue});
    } catch (e) {
      notifier.value = old;
      emit(VideoErrorState(e.toString()));
    }
  }

  void resetLocalData() {
    videoTimeController.clear();
    videoTitleController.clear();
    ownerNameController.clear();
    videoUrlController.clear();
    thumbnailNotifier.value = null;
    ownerImageNotifier.value = null;
  }
}
