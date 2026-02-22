import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/bloc/videoBloc/video_cubit.dart';
import 'package:paw_pal_admin/core/AppColors.dart';
import 'package:paw_pal_admin/routes/routes.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_admin/utils/widget_helper.dart';

import '../../core/constant.dart' show Constant;

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoCubit cubit;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  void initScreen() async {
    cubit = context.read<VideoCubit>();
    await cubit.getPetCareVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 28.0),
        child: FloatingActionButton(
          onPressed: () {
            context.pushNamed(Routes.addVideoScreen);
          },
          backgroundColor: AppColors.primaryColor,
          shape: const CircleBorder(),
          child: Icon(Icons.add, color: AppColors.white, size: 30),
        ),
      ),
      body: GradientBackground(child: mainView()),
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
            commonBackWithHeader(context: context, title: "Manage Videos"),
            const SizedBox(height: 20),
            commonTitle(
              title: "Control Video Visibility",
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            commonTitle(
              title:
                  "Choose whether this video is shown to users in the PawPal app.",
              fontSize: 16,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<VideoCubit, VideoState>(
                builder: (context, state) {
                  if (state is VideoLoadingState) {
                    return videoLoadingView();
                  } else if (state is VideoErrorState) {
                    return commonTitle(title: state.error);
                  }
                  return RefreshIndicator(
                    onRefresh: cubit.getPetCareVideos,
                    child: CustomScrollView(slivers: [buildPetCareVideoList()]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList buildPetCareVideoList() {
    final videoCount = cubit.lstPetCareVideo.length > Constant.staticCount
        ? Constant.staticCount
        : cubit.lstPetCareVideo.length;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final video = cubit.lstPetCareVideo[index];
        final isVisible = cubit.isVisibleUserStatus.putIfAbsent(
          video.id,
          () => ValueNotifier<bool>(video.isVisible),
        );
        return commonPetCareVideoCard(
          videoId: video.id,
          thumbnail: video.thumbnail,
          channelImage: video.ownerImage,
          channelName: video.ownerName,
          duration: video.videoTime,
          videoTitle: video.videoTitle,
          videoUrl: video.videoUrl,
          isVisible: isVisible,
          onChange: (value) {
            cubit.toggleVisibleStatus(video.id, value);
          },
        );
      }, childCount: videoCount),
    );
  }

  Widget videoLoadingView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 200)]);
  }
}
