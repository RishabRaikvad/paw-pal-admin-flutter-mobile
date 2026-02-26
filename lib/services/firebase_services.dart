import 'package:paw_pal_admin/model/product_category_model.dart';
import 'package:paw_pal_admin/model/video_model.dart';
import 'package:paw_pal_admin/services/firestore_service.dart';

import '../model/faq_model.dart';

class FirebaseServices {
  final fireStore = FireStoreService().fireStore;

  Future<void> createPetCareVideo(VideoModel video) async {
    await fireStore
        .collection("pet_care_videos")
        .doc(video.id)
        .set(video.toJson());
  }

  Future<void> createFaq(FaqModel faq) async {
    await fireStore.collection("faq's").doc(faq.id).set(faq.toJson());
  }

  Future<void> deleteFaq(String id) async {
    await fireStore.collection("faq's").doc(id).delete();
  }

  Future<void> updateFaq({
    required Map<String, dynamic> object,
    required String id,
  }) async {
    await fireStore.collection("faq's").doc(id).update(object);
  }

  Future<void> createProductCategory(ProductCategoryModel category) async {
    await fireStore
        .collection("product_category")
        .doc(category.id)
        .set(category.toJson());
  }

  Future<List<ProductCategoryModel>> getProductCategory() async {
    final snapshot = await fireStore.collection("product_category").get();
    return snapshot.docs
        .map((e) => ProductCategoryModel.fromJson(e.data()))
        .toList();
  }
}
