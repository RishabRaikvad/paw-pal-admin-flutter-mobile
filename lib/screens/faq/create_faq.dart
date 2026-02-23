import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/bloc/faqBloc/faq_cubit.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';

import '../../core/AppColors.dart';
import '../../utils/widget_helper.dart';

class CreateFaq extends StatefulWidget {
  const CreateFaq({super.key});

  @override
  State<CreateFaq> createState() => _CreateFaqState();
}

class _CreateFaqState extends State<CreateFaq> {
  late FaqCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<FaqCubit>();
    cubit.resetLocalData();
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
            commonBackWithHeader(context: context, title: "FAQ’s"),
            const SizedBox(height: 20),
            commonTitle(
              title: "Help Users Faster",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 4),
            commonTitle(
              title: "Write a question and answer users can easily understand.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            const SizedBox(height: 40),
            commonTextFieldWithLabel(
              label: "What would users like to know?",
              hint: "Please enter a clear question.",
              context: context,
              controller: cubit.questionController,
            ),
            const SizedBox(height: 20),
            commonTextFieldWithLabel(
              label: "Write a clear and helpful answer",
              hint: "Provide a simple explanation users can understand.",
              context: context,
              controller: cubit.answerController,
            ),
            Spacer(),
            buttonView(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buttonView() {
    return BlocBuilder<FaqCubit, FaqState>(
      builder: (context, state) {
        final isLoading = state is AddFaqLoadState;
        return commonButtonView(
          context: context,
          buttonText: "Publish FAQ",
          onClicked: () {
            cubit.createFaq(context);
          },
          isLoading: isLoading,
        );
      },
    );
  }
}
