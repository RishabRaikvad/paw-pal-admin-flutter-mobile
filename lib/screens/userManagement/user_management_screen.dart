import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/bloc/userManagementBloc/user_management_cubit.dart';
import 'package:paw_pal_admin/core/AppColors.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_admin/utils/widget_helper.dart';

import '../../utils/ui_helper.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late UserManagementCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<UserManagementCubit>();
    cubit.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GradientBackground(child: mainView()));
  }

  Widget mainView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            commonBackWithHeader(context: context, title: "Manage users"),
            const SizedBox(height: 20),
            commonTitle(
              title: "User Management",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            commonTitle(
              title:
                  "View, manage, and monitor all registered users in one place.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<UserManagementCubit, UserManagementState>(
                builder: (context, state) {
                  if (state is UserManagementLoading) {
                    return loadingUserView();
                  } else if (state is UserManagementError) {
                    return Center(child: commonTitle(title: state.error));
                  }
                  return CustomScrollView(
                    slivers: [
                      cubit.lstUserList.isNotEmpty
                          ? userListView()
                          :
                      SliverToBoxAdapter(
                              child: SizedBox(
                                height : UIHelper.screenHeight(context) * 0.5,
                                child: Center(
                                  child: commonTitle(title: "User Not Available"),
                                ),
                              ),
                            ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList userListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final user = cubit.lstUserList[index];
        return userCardView(
          userName: user.name,
          userEmail: user.email,
          userProfile: user.profileImageUrl ?? "",
          userAddress: cubit.getUserAddress(user),
          userPhoneNumber: user.phone,
          petCount: cubit.getPetCount(user.uid),
        );
      }, childCount: cubit.lstUserList.length),
    );
  }

  Widget userCardView({
    required String userName,
    required String userEmail,
    required String userProfile,
    required String userAddress,
    required String userPhoneNumber,
    required int petCount,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                ClipOval(
                  child: commonNetworkImage(
                    imageUrl: userProfile,
                    width: 50,
                    height: 50,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonTitle(
                      title: userName,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    commonTitle(
                      title: userEmail,
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            commonDottedLine(),
            const SizedBox(height: 10),
            commonTitle(
              title: "Address",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 3),
            commonTitle(
              title: userAddress,
              fontSize: 14,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonTitle(
                  title: "+91 ${CommonMethods.formatPhone(userPhoneNumber)}",
                  color: AppColors.primaryColor,
                  fontSize: 14,
                ),
                if (petCount != 0)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: commonTitle(
                      title: "${petCount.toString()} Pets",
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingUserView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 250)]);
  }
}
