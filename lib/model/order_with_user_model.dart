import 'package:paw_pal_admin/model/order_model.dart';

class OrderWithUser {
  final OrderModel order;
  final String userName;
  final String userLastName;
  final String? userProfile;

  OrderWithUser({
    required this.order,
    required this.userName,
    required this.userLastName,
    this.userProfile,
  });
}