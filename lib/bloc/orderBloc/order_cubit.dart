import 'package:bloc/bloc.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';

import '../../model/order_model.dart';
import '../../model/order_with_user_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  FirebaseServices service;

  OrderCubit(this.service) : super(OrderInitial());
  List<OrderWithUser> lstOrder = [];

  Future<void> getOrders() async {
    emit(OrderLoadingState());
    try {
      final orders = await service.getOrders();
      final result = await Future.wait(
        orders.map((order) async {
          final user = await service.getUserById(order.userId);

          return OrderWithUser(
            order: order,
            userName: user?['name'] ?? "",
            userProfile: user?['profileImageUrl'] ?? "",
            userLastName: user?['lastName'] ?? "",
          );
        }),
      );
      lstOrder = result;
      emit(OrderSuccessState());
    } catch (e) {
      emit(OrderErrorState(e.toString()));
    }
  }
}
