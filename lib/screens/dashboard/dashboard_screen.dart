import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_admin/bloc/dashboardBloc/dashboard_cubit.dart';
import 'package:paw_pal_admin/core/AppColors.dart';
import 'package:paw_pal_admin/core/AppImages.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/utils/widget_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/commonWidget/custom_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DashboardCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<DashboardCubit>();
    cubit.getDashboardData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.linearBg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        drawer: const CustomDrawer(),
        body: SafeArea(child: mainView()),
      ),
    );
  }

  Widget mainView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(children: [SvgPicture.asset(AppImages.icDrawer)]),
                  Center(
                    child: commonTitle(
                      title: "Dashboard",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if(state is DashboardLoading){
                  return shimmerView();
                }else if(state is DashboardErrorState){
                  return Center(child: commonTitle(title: state.error),);
                }
                return dashboardView();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        totalRevenueCard(),
        const SizedBox(height: 15),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: dashBoardCardView(
                icon: AppImages.icTotalUser,
                title: "Total User",
                count: cubit.totalUsers.toString(),
              ),
            ),
            Expanded(
              child: dashBoardCardView(
                icon: AppImages.icTotalHospital,
                title: "Total Hospitals",
                count: cubit.totalHospital.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: dashBoardCardView(
                icon: AppImages.icTotalVideo,
                title: "Total Video",
                count: cubit.totalVideo.toString(),
              ),
            ),
            Expanded(
              child: dashBoardCardView(
                icon: AppImages.icTotalProduct,
                title: "Total Products",
                count: cubit.totalProducts.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        totalOrderCard(),
        const SizedBox(height: 15),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: dashBoardCardView(
                icon: AppImages.icTotalProductCategory,
                title: "Total Product Category",
                count: cubit.totalProductCategory.toString(),
              ),
            ),
            Expanded(
              child: dashBoardCardView(
                icon: AppImages.icTotalPetCategory,
                title: "Total Pet Category",
                count: cubit.totalPetCategory.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget dashBoardCardView({
    required String icon,
    required String title,
    required String count,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon),
            const SizedBox(height: 10),
            commonTitle(
              title: count,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 2),
            commonTitle(
              title: title,
              fontSize: 14,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget totalRevenueCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(AppImages.icTotalRevenue),
            const SizedBox(height: 10),
            commonTitle(
              title: CommonMethods.formatPrice(cubit.totalRevenue),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 2),
            commonTitle(
              title: "Total Revenue",
              fontSize: 14,
              color: AppColors.grey,
            ),
            const SizedBox(height: 15),
            commonDottedLine(),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonTitle(
                          title: CommonMethods.formatPrice(cubit.petRevenue),
                          textAlign: TextAlign.start,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        commonTitle(
                          title: "Pet Creation Revenue",
                          fontSize: 13,
                          color: AppColors.grey,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),
                  verticalDottedLine(height: 60),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonTitle(
                          title: CommonMethods.formatPrice(cubit.orderRevenue),
                          textAlign: TextAlign.start,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        commonTitle(
                          title: "Total Product Revenue",
                          fontSize: 13,
                          color: AppColors.grey,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalOrderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(AppImages.icTotalOrder),
            const SizedBox(height: 10),
            commonTitle(
              title: cubit.totalOrders.toString(),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 2),
            commonTitle(
              title: "Total Orders",
              fontSize: 14,
              color: AppColors.grey,
            ),
            const SizedBox(height: 15),
            commonDottedLine(),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        commonTitle(
                          title: cubit.delivered.toString(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        commonTitle(
                          title: "Delivered",
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),
                  verticalDottedLine(height: 40),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        commonTitle(
                          title: cubit.pending.toString(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        commonTitle(
                          title: "Pending",
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),
                  verticalDottedLine(height: 40),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        commonTitle(
                          title: cubit.cancelled.toString(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        commonTitle(
                          title: "Cancelled",
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerView() {
    return Column(
      children: [
        shimmerCard(height: 220),
        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(child: shimmerCard(height: 110)),
            const SizedBox(width: 10),
            Expanded(child: shimmerCard(height: 110)),
          ],
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(child: shimmerCard(height: 110)),
            const SizedBox(width: 10),
            Expanded(child: shimmerCard(height: 110)),
          ],
        ),

        const SizedBox(height: 15),

        shimmerCard(height: 220),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(child: shimmerCard(height: 110)),
            const SizedBox(width: 10),
            Expanded(child: shimmerCard(height: 110)),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget shimmerCard({double height = 100}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
