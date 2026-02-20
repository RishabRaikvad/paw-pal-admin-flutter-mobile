import 'package:paw_pal_admin/model/video_model.dart';
import 'package:paw_pal_admin/services/firestore_service.dart';

class FirebaseServices {
  final fireStore = FireStoreService().fireStore;

  Future<void> createPetCareVideo(VideoModel video) async {
    await fireStore
        .collection("pet_care_videos")
        .doc(video.id)
        .set(video.toJson());
  }
}
