import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/bloc/videoBloc/video_cubit.dart';
import 'package:paw_pal_admin/core/AppImages.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';

import '../../core/AppColors.dart';
import '../../utils/widget_helper.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  late VideoCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<VideoCubit>();
  }

  @override
  void dispose() {
    cubit.resetLocalData();
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
            commonTitle(
              title: "Upload Pet Care Video",
              fontSize: 20,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: uploadVideoFormView()),
                  SliverToBoxAdapter(child: buildUploadBtn()),
                  SliverToBoxAdapter(child: const SizedBox(height: 30)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadVideoFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Video Thumbnail",
          textAlign: TextAlign.start,
          fontSize: 16,
          color: AppColors.grey,
        ),
        const SizedBox(height: 10),
        uploadImageView(
          context: context,
          uploadedImage: cubit.thumbnailNotifier,
          image: AppImages.icMainPet,
          width: double.infinity,
          height: 200,
        ),
        const SizedBox(height: 25),

        commonTextFieldWithLabel(
          label: "Video Title",
          hint: "Enter video title",
          context: context,
          controller: cubit.videoTitleController,
        ),

        const SizedBox(height: 20),

        commonTextFieldWithLabel(
          label: "Video Duration",
          hint: "Eg: 10:30",
          context: context,
          controller: cubit.videoTimeController,
          inputType: TextInputType.number,
        ),

        const SizedBox(height: 20),

        commonTextFieldWithLabel(
          label: "Video URL",
          hint: "Paste video link here",
          context: context,
          controller: cubit.videoUrlController,
          inputType: TextInputType.url,
        ),

        const SizedBox(height: 30),

        commonTitle(
          title: "Owner Details",
          fontSize: 16,
          color: AppColors.grey,
          textAlign: TextAlign.start,
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            uploadImageView(
              context: context,
              uploadedImage: cubit.ownerImageNotifier,
              image: AppImages.icMainPet,
              width: 80,
              height: 80,
              radius: 50,
              boxFit: BoxFit.cover,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: commonTextFieldWithLabel(
                label: "Owner Name",
                hint: "Enter owner name",
                context: context,
                controller: cubit.ownerNameController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget buildUploadBtn() {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        final isLoading = state is VideoAddLoadingState;
        return commonButtonView(
          context: context,
          buttonText: "Upload Video",
          onClicked: () {
            cubit.uploadPetCareVideo(context);
          },
          isLoading: isLoading,
        );
      },
    );
  }
}
