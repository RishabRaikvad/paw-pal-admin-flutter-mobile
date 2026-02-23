import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/core/AppImages.dart';
import 'package:paw_pal_admin/model/faq_model.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_admin/utils/dialog_utils.dart';

import '../../bloc/faqBloc/faq_cubit.dart';
import '../../core/AppColors.dart';
import '../../routes/routes.dart';
import '../../utils/widget_helper.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late FaqCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<FaqCubit>();
    cubit.getFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: commonFlotButton(context, Routes.createFaqScreen),
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
            commonBackWithHeader(context: context, title: "FAQ’s"),
            const SizedBox(height: 20),
            commonTitle(
              title: "Frequently Asked Questions",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            commonTitle(
              title:
                  "Manage and update frequently asked questions shown to users.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<FaqCubit, FaqState>(
                builder: (context, state) {
                  if (state is FaqLoadState) {
                    return faqShimmer();
                  } else if (state is FaqErrorState) {
                    return Center(child: commonTitle(title: state.error));
                  }
                  return CustomScrollView(slivers: [faqList()]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList faqList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final faq = cubit.lstFaq[index];
        return faqView(
          question: faq.question,
          answer: faq.answer,
          onDelete: () {
            DialogUtils.deleteFaqDialog(
              onTap: () {
                cubit.deleteFaq(faq.id, context);
              },
              context: context,
            );
          },
          onEdit: () {
            showEditBottomSheet(faq);
          },
        );
      }, childCount: cubit.lstFaq.length),
    );
  }

  Widget faqView({
    required String question,
    required String answer,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
  }) {
    return GestureDetector(
      onTap: onEdit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonTitle(
                  title: question,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  maxLines: 1,
                  overFlow: TextOverflow.ellipsis,
                ),
                commonTitle(
                  title: answer,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                  maxLines: 3,
                  overFlow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          InkResponse(
            onTap: onDelete,
            child: SvgPicture.asset(AppImages.icDelete),
          ),
        ],
      ),
    );
  }

  Widget faqShimmer() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 80)]);
  }

  void showEditBottomSheet(FaqModel faq) {
    cubit.questionController.text = faq.question;
    cubit.answerController.text = faq.answer;

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
                  minHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonTitle(
                      title: "Edit Help Content",
                      fontSize: 22,
                      textAlign: TextAlign.start,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: 4),

                    commonTitle(
                      title:
                          "Update the question and answer to keep information clear and accurate.",
                      fontSize: 16,
                      textAlign: TextAlign.start,
                      color: AppColors.grey,
                    ),

                    const SizedBox(height: 25),

                    commonTextFieldWithLabel(
                      label: "What would users like to know?",
                      hint: "Please enter a clear question.",
                      context: context,
                      controller: cubit.questionController,
                    ),

                    const SizedBox(height: 20),

                    commonTextFieldWithLabel(
                      label: "Write a clear and helpful answer",
                      hint:
                          "Provide a simple explanation users can understand.",
                      context: context,
                      controller: cubit.answerController,
                    ),

                    const SizedBox(height: 30),

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
                          child: BlocBuilder<FaqCubit, FaqState>(
                            builder: (context, state) {
                              return commonButtonView(
                                context: context,
                                buttonText: "Update FAQ",
                                onClicked: () {
                                  cubit.updateFaq(
                                    context: context,
                                    id: faq.id
                                  );
                                  },
                              );
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
}
