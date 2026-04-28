import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/bloc/orderBloc/order_cubit.dart';

import 'package:paw_pal_admin/model/order_model.dart';
import 'package:paw_pal_admin/model/order_with_user_model.dart';
import 'package:paw_pal_admin/services/firebase_services.dart';

import '../../core/AppStrings.dart';
import '../../core/CommonMethods.dart';
import '../../progress_loader_screen.dart';
import '../../routes/routes.dart';

part 'order_detail_state.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderWithUser? model;
  FirebaseServices services;

  OrderDetailCubit(this.services) : super(OrderDetailInitial());

  void navigateToOrderDetailScreen(BuildContext context, OrderWithUser model) {
    this.model = model;
    context.pushNamed(Routes.orderDetailScreen);
    emit(OrderDetailSuccessState());
  }

  String getOrderAddressDetail(ShippingAddress address) {
    return "${address.address} ${address.city} ${address.state} ${address.pinCode}";
  }

  String getOrderUserDetail(ShippingAddress address) {
    return "${address.name} ${AppStrings.dot} +91${address.phone}";
  }

  Future<void> deliveredOrder(BuildContext context, String orderId) async {
    LoadingDialog.show(context);
    try {
      await services.deliveredOrder(orderId);
      if (!context.mounted) return;
      await context.read<OrderCubit>().getOrders();
      if (context.mounted) {
        context.pop();
      }

      CommonMethods().showSuccessToast("Your order Delivered successfully.");
    } catch (e) {
      debugPrint("Errrorwnedkv : ${e.toString()}");
      CommonMethods().showErrorToast(e.toString());
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
    }
  }
}
