import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/bloc/petCategoryBloc/pet_category_cubit.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';

import '../../core/AppColors.dart';
import '../../utils/widget_helper.dart';

class CreatePetCategoryScreen extends StatefulWidget {
  const CreatePetCategoryScreen({super.key});

  @override
  State<CreatePetCategoryScreen> createState() =>
      _CreatePetCategoryScreenState();
}

class _CreatePetCategoryScreenState extends State<CreatePetCategoryScreen> {
  late PetCategoryCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<PetCategoryCubit>();
    cubit.reset();
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

            commonBackWithHeader(context: context, title: "Pet Category"),

            const SizedBox(height: 20),

            commonTitle(
              title: "Create New Pet Category",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 4),

            commonTitle(
              title:
              "Organize pets into categories for better browsing and adoption.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),

            const SizedBox(height: 50),

            commonTextFieldWithLabel(
              label: "Pet Category",
              hint: "Enter Pet Category",
              context: context,
              controller: cubit.categoryController,
            ),
            const SizedBox(height: 30),
            BlocBuilder<PetCategoryCubit, PetCategoryState>(
              builder: (context, state) {
                final isLoading = state is AddPetLoadState;
                return commonButtonView(context: context,
                    buttonText: "Publish Pet Category",
                    isLoading: isLoading,
                    onClicked: () {
                      cubit.createPetCategory(context);
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
