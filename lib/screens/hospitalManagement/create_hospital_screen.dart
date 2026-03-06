import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/bloc/hospitalBloc/hospital_cubit.dart';
import 'package:paw_pal_admin/core/AppColors.dart';
import 'package:paw_pal_admin/core/AppImages.dart';
import 'package:paw_pal_admin/progress_loader_screen.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_admin/utils/dialog_utils.dart';
import 'package:paw_pal_admin/utils/widget_helper.dart';

class CreateHospitalScreen extends StatefulWidget {
  const CreateHospitalScreen({super.key});

  @override
  State<CreateHospitalScreen> createState() => _CreateHospitalScreenState();
}

class _CreateHospitalScreenState extends State<CreateHospitalScreen> {
  late HospitalCubit cubit;
  bool get isEdit => cubit.hospitalModel != null;

  @override
  void initState() {
    super.initState();
    cubit = context.read<HospitalCubit>();
    if (isEdit) {
      cubit.setHospitalData(cubit.hospitalModel!);
    }
  }

  @override
  void dispose() {
    cubit.resetHospitalForm();
    super.dispose();
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
            commonBackWithHeader(context: context, title: "Add Hospital"),
            const SizedBox(height: 20),
            commonTitle(
              title: "Create Hospital Profile",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            commonTitle(
              title:
                  "Add complete and accurate hospital details to build trust and help users find the right care.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: basicInfoView()),
                  SliverToBoxAdapter(child: const SizedBox(height: 10)),
                  SliverToBoxAdapter(child: contactDetails()),
                  SliverToBoxAdapter(child: const SizedBox(height: 20)),

                  SliverToBoxAdapter(child: availabilityScheduleView()),
                  SliverToBoxAdapter(child: const SizedBox(height: 30)),
                  SliverToBoxAdapter(child: hospitalBtn()),
                  SliverToBoxAdapter(child: const SizedBox(height: 30)),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget basicInfoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Hospital Basic Information",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 15),

        commonTextFieldWithLabel(
          label: "Hospital Name",
          hint: "Enter Hospital Name",
          context: context,
          controller: cubit.nameController,
        ),

        const SizedBox(height: 20),

        commonTextFieldWithLabel(
          label: "About Hospital",
          hint: "Write a short description about services & facilities..",
          context: context,
          controller: cubit.descriptionController,
          maxLines: 4,
          maxLength: 200,
        ),

        const SizedBox(height: 20),

        commonTitle(
          title: "Specializations",
          fontSize: 16,
          color: AppColors.grey,
        ),
        const SizedBox(height: 8),
        BlocBuilder<HospitalCubit, HospitalState>(
          builder: (context, state) {
            return Wrap(
              spacing: 8,
              runSpacing: 10,
              children: List.generate(cubit.specializations.length, (index) {
                final spec = cubit.specializations[index];
                final isSelected = cubit.selectedSpecializations.contains(spec);

                return GestureDetector(
                  onTap: () {
                    cubit.addSpecializations(spec);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.grey,
                      ),
                      color: isSelected
                          ? AppColors.variantColor
                          : AppColors.inputBgColor.withValues(alpha: 0.05),
                    ),
                    child: commonTitle(
                      title: spec,
                      fontSize: 13,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.grey,
                    ),
                  ),
                );
              }),
            );
          },
        ),

        const SizedBox(height: 20),
        commonTitle(
          title: "Upload Hospital Image",
          fontSize: 16,
          color: AppColors.grey,
        ),
        const SizedBox(height: 8),
        uploadImageView(
          context: context,
          uploadedImage: cubit.hospitalImageNotifier,
          image: AppImages.icMainPet,
          width: double.infinity,
          height: 200,
        ),
        const SizedBox(height: 15),
        commonDottedLine(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget contactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Contact Details",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 15),

        commonTextFieldWithLabel(
          label: "Contact Number",
          hint: "Enter Mobile Number",
          context: context,
          controller: cubit.phoneController,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: commonTitle(title: "+91"),
          ),
          inputType: TextInputType.phone,
          maxLength: 10,
          inputFormatter: [FilteringTextInputFormatter.digitsOnly],
        ),

        const SizedBox(height: 20),

        commonTextFieldWithLabel(
          label: "Address",
          hint: "Enter Address",
          context: context,
          controller: cubit.addressController,
          maxLines: 3,
          maxLength: 200,
        ),
      ],
    );
  }

  Widget availabilityScheduleView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Availability Schedule",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 15),

        BlocBuilder<HospitalCubit, HospitalState>(
          builder: (context, state) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cubit.availabilityList.length,
              itemBuilder: (context, index) {
                final data = cubit.availabilityList[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        commonTitle(title: data.day, fontSize: 16),
                        Transform.scale(
                          scale: 0.9,
                          child: Switch(
                            value: data.isOpen ?? false,
                            onChanged: (value) {
                              cubit.toggleDayAvailability(index, value);
                            },
                            activeTrackColor: AppColors.greenColor,
                            inactiveTrackColor: Colors.grey.withValues(alpha: 0.5),
                            inactiveThumbColor: AppColors.white,
                            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                          ),
                        ),
                      ],
                    ),

                    if (data.isOpen ?? false)
                      data.startTime == null && data.endTime == null
                          ? GestureDetector(
                              onTap: () {
                                setOrUpdateAvailabilityHoursBottomSheet(index);
                              },
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.primaryColor,
                                    size: 25,
                                  ),
                                  commonTitle(
                                    title: "Add Availability",
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.variantColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  commonTitle(
                                    title:
                                        '${data.startTime} - ${data.endTime}',
                                    fontSize: 14,
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      editAvailabilityBottomSheet(index);
                                    },
                                    child: SvgPicture.asset(AppImages.icEdit),
                                  ),
                                ],
                              ),
                            ),
                    const SizedBox(height: 10),
                    commonDottedLine(),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  void setOrUpdateAvailabilityHoursBottomSheet(int index) {
    DialogUtils.openBottomSheetDialog(
      context: context,
      isScrollControlled: true,
      contentWidget: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = MediaQuery.of(context).size.height * 0.85;
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.38,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    commonTitle(
                      title: "Set Daily Working Hours",
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 2),
                    commonTitle(
                      title:
                          "Define opening and closing hours to reflect the hospital’s daily availability.",
                      fontSize: 16,
                      color: AppColors.grey,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      spacing: 10,
                      children: [
                        Flexible(
                          child: commonTextFieldWithLabel(
                            label: "Opening Time",
                            hint: "Select Time",
                            context: context,
                            controller: cubit.openingController,
                            onClick: () {
                              cubit.pickTime(
                                context: context,
                                controller: cubit.openingController,
                              );
                            },
                          ),
                        ),
                        Flexible(
                          child: commonTextFieldWithLabel(
                            label: "Closing Time",
                            hint: "Select Time",
                            context: context,
                            controller: cubit.closingController,
                            onClick: () {
                              cubit.pickTime(
                                context: context,
                                controller: cubit.closingController,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      spacing: 10,
                      children: [
                        Flexible(
                          child: commonOutLineButtonView(
                            context: context,
                            buttonText: "Cancel",
                            onClicked: () {
                              context.pop();
                            },
                          ),
                        ),
                        Flexible(
                          child: commonButtonView(
                            context: context,
                            buttonText: "Add Hours",
                            onClicked: () {
                              cubit.setOrUpdateAvailability(index);
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void editAvailabilityBottomSheet(int index) {
    final data = cubit.availabilityList[index];

    cubit.openingController.text = data.startTime ?? "";
    cubit.closingController.text = data.endTime ?? "";

    DialogUtils.openBottomSheetDialog(
      context: context,
      isScrollControlled: true,
      contentWidget: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = MediaQuery.of(context).size.height * 0.85;

          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.38,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    commonTitle(
                      title: "Update Daily Working Hours",
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: 2),

                    commonTitle(
                      title:
                          "Modify opening and closing times to keep availability information accurate.",
                      fontSize: 16,
                      color: AppColors.grey,
                      textAlign: TextAlign.start,
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Flexible(
                          child: commonTextFieldWithLabel(
                            label: "Opening Time",
                            hint: "Select Time",
                            context: context,
                            controller: cubit.openingController,
                            onClick: () {
                              cubit.pickTime(
                                context: context,
                                controller: cubit.openingController,
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Flexible(
                          child: commonTextFieldWithLabel(
                            label: "Closing Time",
                            hint: "Select Time",
                            context: context,
                            controller: cubit.closingController,
                            onClick: () {
                              cubit.pickTime(
                                context: context,
                                controller: cubit.closingController,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Flexible(
                          child: commonOutLineButtonView(
                            context: context,
                            buttonText: "Cancel",
                            onClicked: () {
                              context.pop();
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Flexible(
                          child: commonButtonView(
                            context: context,
                            buttonText: "Update Hours",
                            onClicked: () {
                              cubit.setOrUpdateAvailability(index);
                              context.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget hospitalBtn() {
    return BlocBuilder<HospitalCubit, HospitalState>(
      builder: (context, state) {
        final isLoading = state is HospitalCreateLoading;
        return commonButtonView(
          context: context,
          buttonText: "Save Hospital",
          onClicked: () {
            cubit.createHospital(context);
          },
          isLoading: isLoading,
        );
      },
    );
  }
}
