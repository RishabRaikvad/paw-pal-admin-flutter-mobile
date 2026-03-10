import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/hospitalBloc/hospital_cubit.dart';
import '../../core/AppColors.dart';
import '../../core/AppImages.dart';
import '../../model/hospital_model.dart';
import '../../routes/routes.dart';
import '../../utils/commonWidget/gradient_background.dart';
import '../../utils/ui_helper.dart';
import '../../utils/widget_helper.dart';

class VetCareScreen extends StatefulWidget {
  const VetCareScreen({super.key});

  @override
  State<VetCareScreen> createState() => _VetCareScreenState();
}

class _VetCareScreenState extends State<VetCareScreen> {
  late HospitalCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<HospitalCubit>();
    cubit.getHospitals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(child: mainView()),
      floatingActionButton: commonFlotButton(
        context,
        Routes.createHospitalScreen,
      ),
    );
  }

  Widget mainView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            commonBackWithHeader(context: context, title: "Hospital"),
            const SizedBox(height: 20),
            commonTitle(
              title: "Hospital Directory",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            commonTitle(
              title:
                  "Manage hospital profiles, control visibility, and keep information up to date.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<HospitalCubit, HospitalState>(
                builder: (context, state) {
                  if (state is HospitalLoading) {
                    return hospitalShimmerView();
                  } else if (state is HospitalError) {
                    return Center(child: commonTitle(title: state.error));
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getHospitals,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: commonTitle(
                            title: "Veterinary Care Centers",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SliverToBoxAdapter(child: const SizedBox(height: 5)),
                        cubit.lstHospital.isNotEmpty
                            ? careCenterList()
                            : SliverToBoxAdapter(
                                child: SizedBox(
                                  height: UIHelper.screenHeight(context) * 0.5,
                                  child: Center(
                                    child: commonTitle(
                                      title: "No Hospital Available",
                                    ),
                                  ),
                                ),
                              ),
                        SliverToBoxAdapter(child: const SizedBox(height: 100)),
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

  SliverList careCenterList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final hospital = cubit.lstHospital[index];
        return careCenterView(
          hospitalName: hospital.hospitalName,
          img: hospital.imageUrl,
          address: hospital.address,
          model: hospital,
          index: index
        );
      }, childCount: cubit.lstHospital.length),
    );
  }

  Widget careCenterView({
    required String img,
    required String hospitalName,
    required String address,
    required HospitalModel model,
    required int index,
  }) {
    return GestureDetector(
      onTap: (){
        cubit.navigateForEdit(context, model);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                commonNetworkImage(
                  imageUrl: img,
                  boarderRadiusOnly: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  height: 200,
                  width: double.infinity
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        commonTitle(
                          title: "Visible to User",
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 20,
                          child: Transform.scale(
                            scale: 0.85,
                            child: Switch(
                              value: model.isAvailable,
                              onChanged: (newValue) {
                                cubit.updateAvailabilityOfHospital(
                                  index,
                                  newValue,
                                  model.id,
                                );
                              },
                              activeTrackColor: AppColors.greenColor,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              inactiveTrackColor: Colors.grey.withValues(alpha: 0.5),
                              inactiveThumbColor: AppColors.white,
                              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                spacing: 5,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 20,
                    children: [
                      Flexible(
                        child: commonTitle(
                          title: hospitalName,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overFlow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          commonTitle(
                            title: "View Details",
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            isUnderLine: true,
                          ),
                          SvgPicture.asset(AppImages.icViewDetailArrow),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppImages.icLocation),
                      Flexible(
                        child: commonTitle(
                          title: address,
                          fontSize: 14,
                          color: AppColors.grey,
                          maxLines: 2,
                          overFlow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      CircleAvatar(backgroundColor: AppColors.grey, radius: 3),
                      commonTitle(
                        title: cubit.isOpenNow(model) ? "Open Now" : "Close Now",
                        fontSize: 14,
                        color: cubit.isOpenNow(model)
                            ? AppColors.greenColor
                            : AppColors.redColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hospitalShimmerView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 250)]);
  }
}
