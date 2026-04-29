import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/bloc/petCategoryBloc/pet_category_cubit.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';

import '../../core/AppColors.dart';
import '../../routes/routes.dart';
import '../../utils/ui_helper.dart';
import '../../utils/widget_helper.dart';

class PetCategoryScreen extends StatefulWidget {
  const PetCategoryScreen({super.key});

  @override
  State<PetCategoryScreen> createState() => _PetCategoryScreenState();
}

class _PetCategoryScreenState extends State<PetCategoryScreen> {
  late PetCategoryCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<PetCategoryCubit>();
    cubit.getPetCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: commonFlotButton(
        context,
        Routes.createPetCategoryScreen,
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

            commonBackWithHeader(context: context, title: "Pet Category"),

            const SizedBox(height: 20),

            commonTitle(
              title: "Pet Category Management",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 4),

            commonTitle(
              title:
                  "Organize and manage categories to keep your app structured and easy to navigate.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<PetCategoryCubit, PetCategoryState>(
                builder: (context, state) {
                  if (state is PetCategoryLoadState) {
                    return loadCategoryView();
                  }
                  return commonRefreshIndicator(
                    onRefresh: cubit.getPetCategory,
                    child: CustomScrollView(
                      slivers: [
                        cubit.lstPetCategory.isNotEmpty
                            ? petCategoryListView()
                            : SliverToBoxAdapter(
                                child: SizedBox(
                                  height: UIHelper.screenHeight(context) * 0.5,
                                  child: Center(
                                    child: commonTitle(
                                      title: "No Pet Category Available",
                                    ),
                                  ),
                                ),
                              ),
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

  SliverList petCategoryListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final category = cubit.lstPetCategory[index];
        return categoryView(categoryName: category.categoryName);
      }, childCount: cubit.lstPetCategory.length),
    );
  }

  Widget categoryView({required String categoryName}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.plashHolderColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: commonTitle(
          title: categoryName,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget loadCategoryView() {
    return CustomScrollView(slivers: [shimmerListSliver(height: 50)]);
  }
}
