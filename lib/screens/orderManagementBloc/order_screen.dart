import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/orderBloc/order_cubit.dart';
import '../../bloc/orderDetailBloc/order_detail_cubit.dart';
import '../../core/AppColors.dart';
import '../../core/CommonMethods.dart';
import '../../model/cart_model.dart';
import '../../model/order_model.dart';
import '../../utils/commonWidget/gradient_background.dart';
import '../../utils/widget_helper.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late OrderCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<OrderCubit>();
    cubit.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            commonBackWithHeader(
              context: context,
              title: "Manage Order",
              isShowTitle: true,
            ),
            const SizedBox(height: 30),
            commonTitle(
              title: "Order Management",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            commonTitle(
              title:
                  "Monitor order activity, status updates, and overall performance in real time.",
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 25),
            Flexible(
              child: BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoadingState) {
                    return orderShimmerView();
                  } else if (state is OrderErrorState) {
                    return commonTitle(title: state.error);
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getOrders,
                    child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: const SizedBox(height: 10)),
                        cubit.lstOrder.isNotEmpty
                            ? orderList()
                            : SliverToBoxAdapter(
                                child: commonTitle(
                                  title: "Order is Not Available",
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList orderList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final order = cubit.lstOrder[index];
        return RepaintBoundary(
          child: orderCard(
            totalAmount: order.order.billing.total,
            orderDate: CommonMethods.formatDate(order.order.createdAt),
            lstCartItems: order.order.items,
            orderStatus: order.order.orderStatus,
            onViewDetails: () {
              context.read<OrderDetailCubit>().navigateToOrderDetailScreen(
                context,
                order,
              );
            },
            userName: "${order.userName} ${order.userLastName}",
            userProfile: order.userProfile ?? "",
          ),
        );
      }, childCount: cubit.lstOrder.length),
    );
  }

  Widget orderCard({
    required String userProfile,
    required String userName,
    required double totalAmount,
    required String orderDate,
    required List<CartModel> lstCartItems,
    required OrderStatus orderStatus,
    required VoidCallback onViewDetails,
  }) {
    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.inputBgColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 15,
                children: [
                  ClipOval(
                    child: commonNetworkImage(
                      imageUrl: userProfile,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonTitle(
                          title: userName,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          textAlign: TextAlign.start,
                        ),
                        commonTitle(
                          title: orderDate,
                          color: AppColors.grey,
                          fontSize: 12,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  commonTitle(
                    title: CommonMethods.formatPrice(totalAmount),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 3),
              commonDottedLine(),
              buildProductImage(lstCartItems),
              commonDottedLine(),
              const SizedBox(height: 3),
              orderStatusView(orderStatus, userName),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductImage(List<CartModel> items) {
    int displayCount = items.length > 3 ? 3 : items.length;
    int remaining = items.length - displayCount;
    return Row(
      children: [
        ...List.generate(displayCount, (index) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: commonNetworkImage(
              imageUrl: items[index].productMainImage,
              width: 50,
              height: 50,
              borderRadius: 8,
            ),
          );
        }),
        if (remaining > 0)
          Container(
            margin: EdgeInsets.only(left: 6),
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: commonTitle(
              title: "+$remaining\nMore",
              fontSize: 12,
              color: AppColors.primaryColor,
            ),
          ),
      ],
    );
  }

  Widget orderShimmerView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 200)]);
  }

  Widget orderStatusView(OrderStatus status, String userName) {
    return Container(
      decoration: BoxDecoration(
        color: CommonMethods.getOrderStatusColor(status),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Row(
          spacing: 10,
          children: [
            SvgPicture.asset(CommonMethods.getOrderStatusWiseIcon(status)),
            Flexible(
              child: commonTitle(
                title: CommonMethods.getOrderStatusTitle(status, userName),
                maxLines: 1,
                overFlow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
