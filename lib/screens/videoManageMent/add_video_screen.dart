import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paw_pal_admin/bloc/videoBloc/video_cubit.dart';
import 'package:paw_pal_admin/core/AppImages.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';

import '../../core/AppColors.dart';
import '../../core/AppStrings.dart';
import '../../core/CommonMethods.dart';
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
            commonBackWithHeader(context: context, title: "Upload Video"),
            const SizedBox(height: 20),
            commonTitle(
              title: "Publish Pet Care Video",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            commonTitle(
              title:
                  "Create trusted and informative content for the PawPal community.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
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
        uploadChannelView(),
        const SizedBox(height: 20),
        commonTextFieldWithLabel(
          label: "Channel Name",
          hint: "Enter Channel Name",
          context: context,
          controller: cubit.ownerNameController,
        ),
        const SizedBox(height: 20),
        commonTitle(
          title: "Upload Thumbnail",
          textAlign: TextAlign.start,
          fontSize: 16,
          color: AppColors.grey,
        ),
        const SizedBox(height: 10),
        uploadImageView(
          context: context,
          uploadedImage: cubit.thumbnailNotifier,
          image: AppImages.icThumbnail,
          width: double.infinity,
          height: 200,
        ),
        const SizedBox(height: 20),
        commonTextFieldWithLabel(
          label: "Video Title",
          hint: "Enter video title",
          context: context,
          controller: cubit.videoTitleController,
        ),
        const SizedBox(height: 20),
        commonTextFieldWithLabel(
          label: "Video URL",
          hint: "Enter Video URL/Link",
          context: context,
          controller: cubit.videoUrlController,
          inputType: TextInputType.url,
        ),
        const SizedBox(height: 20),
        commonTextFieldWithLabel(
          label: "Video Duration",
          hint: "Eg: 10:30",
          context: context,
          controller: cubit.videoTimeController,
          inputType: TextInputType.number,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget uploadChannelView() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final image = await CommonMethods.pickAndCompressImage(
                context: context,
              );

              if (image != null) {
                cubit.ownerImageNotifier.value = image;
              }
            },
            child: ValueListenableBuilder<File?>(
              valueListenable: cubit.ownerImageNotifier,
              builder: (context, image, _) {
                return image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(image),
                      )
                    : SvgPicture.asset(AppImages.icUploadProfile);
              },
            ),
          ),

          SizedBox(height: 10),
          commonTitle(title: "Upload Channel Photo", color: AppColors.grey),
        ],
      ),
    );
  }

  Widget buildUploadBtn() {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        final isLoading = state is VideoAddLoadingState;
        return commonButtonView(
          context: context,
          buttonText: "Publish Video",
          onClicked: () {
            cubit.uploadPetCareVideo(context);
          },
          isLoading: isLoading,
        );
      },
    );
  }
}
