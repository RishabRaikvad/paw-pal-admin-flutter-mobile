import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/routes/routes.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';

import '../../bloc/productCategoryBloc/product_category_cubit.dart';
import '../../core/AppColors.dart';
import '../../utils/widget_helper.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late ProductCategoryCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProductCategoryCubit>();
    cubit.getProductCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(child: mainView()),
      floatingActionButton: commonFlotButton(
        context,
        Routes.createProductCategoryScreen,
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

            commonBackWithHeader(context: context, title: "Product Category"),

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
            const SizedBox(height: 30),
            Flexible(
              child: BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
                builder: (context, state) {
                  if (state is FetchCategoryLoadingState) {
                    return categoryShimmer();
                  } else if (state is FetchCategoryErrorState) {
                    return commonTitle(title: state.message);
                  }
                  return CustomScrollView(slivers: [categoryGridView()]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverGrid categoryGridView() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final category = cubit.lstCategory[index];
        return categoryView(
          imgUrl: category.image,
          categoryName: category.categoryName,
        );
      }, childCount: cubit.lstCategory.length),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.88,
      ),
    );
  }

  Widget categoryView({required String imgUrl, required String categoryName}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dividerColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
        child: Column(
          spacing: 8,
          children: [
            ClipOval(
              child: commonNetworkImage(
                imageUrl: imgUrl,
                height: 52,
                width: 52,
              ),
            ),
            commonTitle(
              title: categoryName,
              maxLines: 1,
              overFlow: TextOverflow.ellipsis,
              fontSize: 12,
              color: AppColors.grey,
              fontWeight: FontWeight.w600
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryShimmer() {
    return CustomScrollView(slivers: [shimmerGrid(crossCount: 3, ratio: 0.88)]);
  }
}
