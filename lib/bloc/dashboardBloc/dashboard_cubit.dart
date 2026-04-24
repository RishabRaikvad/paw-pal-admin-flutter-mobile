import 'package:bloc/bloc.dart';
import 'package:paw_pal_admin/services/firestore_service.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  final fireStore = FireStoreService().fireStore;

  double petRevenue = 0;
  double orderRevenue = 0;
  double totalRevenue = 0;

  int totalUsers = 0;
  int totalProducts = 0;
  int totalOrders = 0;
  int totalVideo = 0;
  int totalProductCategory = 0;
  int totalPetCategory = 0;
  int totalHospital = 0;

  int delivered = 0;
  int pending = 0;
  int cancelled = 0;

  Future<void> getDashboardData() async {
    emit(DashboardLoading());

    try {
      petRevenue = 0;
      orderRevenue = 0;
      totalRevenue = 0;

      totalUsers = 0;
      totalProducts = 0;
      totalOrders = 0;
      totalVideo = 0;
      totalProductCategory = 0;
      totalHospital = 0;

      delivered = 0;
      pending = 0;
      cancelled = 0;

      final petSnapshot = await fireStore.collection('pet_creation_fees').get();

      for (var doc in petSnapshot.docs) {
        final data = doc.data();

        if (data.isEmpty) continue;

        final status = data['status'];
        final amount = data['amount'];

        if (status == "Success" && amount != null) {
          petRevenue += (amount as num).toDouble();
        }
      }

      print("✅ Pet Revenue: $petRevenue");

      final orderSnapshot = await fireStore.collection('orders').get();

      totalOrders = orderSnapshot.docs.length;

      for (var doc in orderSnapshot.docs) {
        final data = doc.data();

        if (data.isEmpty) continue;

        final billing = data['billing'];

        if (data['paymentStatus'] == "Success" &&
            billing != null &&
            billing['total'] != null) {
          orderRevenue += (billing['total'] as num).toDouble();
        }

        final status = (data['orderStatus'] ?? "").toString().toLowerCase();

        if (status == "delivered") {
          delivered++;
        } else if (status == "pending") {
          pending++;
        } else if (status == "cancel") {
          cancelled++;
        }
      }

      print("✅ Order Revenue: $orderRevenue");
      print("Delivered: $delivered");
      print("Pending: $pending");
      print("Cancelled: $cancelled");

      final usersSnapshot = await fireStore.collection('users').get();
      totalUsers = usersSnapshot.docs.length;

      final productSnapshot = await fireStore.collection('products').get();
      totalProducts = productSnapshot.docs.length;

      final videoSnapshot = await fireStore.collection('pet_care_videos').get();
      totalVideo = videoSnapshot.docs.length;

      final productCategorySnapshot = await fireStore
          .collection('product_category')
          .get();
      totalProductCategory = productCategorySnapshot.docs.length;

      final hospitalsSnapshot = await fireStore.collection('hospitals').get();
      totalHospital = hospitalsSnapshot.docs.length;

      final petCategorySnapshot = await fireStore
          .collection('pet_category')
          .get();
      totalPetCategory = petCategorySnapshot.docs.length;

      print("Users: $totalUsers");
      print("Products: $totalProducts");
      print("Hospitals: $totalHospital");

      totalRevenue = petRevenue + orderRevenue;

      print("🔥 TOTAL REVENUE: $totalRevenue");

      emit(DashboardSuccessState());
    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("❌ STACK: $stack");
      emit(DashboardErrorState(e.toString()));
    }
  }
}
