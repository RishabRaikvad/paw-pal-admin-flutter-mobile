import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paw_pal_admin/routes/routes.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_admin/utils/ui_helper.dart';
import 'package:paw_pal_admin/utils/widget_helper.dart';

import '../../bloc/productBloc/product_cubit.dart';
import '../../bloc/productCategoryBloc/product_category_cubit.dart';
import '../../core/AppColors.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductCubit cubit;
  late ProductCategoryCubit categoryCubit;

  @override
  void initState() {
    super.initState();
    categoryCubit = context.read<ProductCategoryCubit>();
    cubit = context.read<ProductCubit>();
    categoryCubit.getProductCategory();
    cubit.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: commonFlotButton(
        context,
        Routes.createProductScreen,
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

            commonBackWithHeader(context: context, title: "Products"),

            const SizedBox(height: 20),

            commonTitle(
              title: "Manage Store Products",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 4),

            commonTitle(
              title:
                  "Organize inventory, update details, and control product visibility.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadState) {
                    return productShimmerView();
                  } else if (state is ProductErrorState) {
                    return Center(child: commonTitle(title: state.error));
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: categoryFilterList()),
                      SliverToBoxAdapter(child: const SizedBox(height: 20)),
                      cubit.filteredProducts.isEmpty
                          ? SliverToBoxAdapter(
                              child: SizedBox(
                                height: UIHelper.screenHeight(context) * 0.5,
                                child: Center(
                                  child: commonTitle(title: "No Product Found"),
                                ),
                              ),
                            )
                          : buildShopView(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverGrid buildShopView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 14,
        childAspectRatio: 0.58,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = cubit.filteredProducts[index];
        return commonProductCard(
          imgUrl: product.mainProductImage,
          price: cubit.getProductPrice(product),
          productName: product.name,
          rating: product.rating,
          size: cubit.getProductSize(product) ?? "",
          model: product,
          onChange: (newValue) {
            cubit.updateAvailabilityOfProduct(index, newValue, product.id);
          },
        );
      }, childCount: cubit.filteredProducts.length),
    );
  }

  Widget productShimmerView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: categoryFilterShimmer()),
        SliverToBoxAdapter(child: const SizedBox(height: 20)),
        shimmerGrid(ratio: 0.65, count: 6),
      ],
    );
  }

  Widget categoryFilterList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        commonTitle(
          title: "Everything Your Store Offers",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categoryCubit.lstCategory.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () => cubit.selectAllFilter(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cubit.isAllFilterSelected
                          ? AppColors.primaryColor
                          : AppColors.primaryBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: commonTitle(
                      title: "All",
                      color: cubit.isAllFilterSelected
                          ? AppColors.white
                          : AppColors.grey,
                      fontSize: 14,
                      fontWeight: cubit.isAllFilterSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                );
              }

              final category = categoryCubit.lstCategory[index - 1];

              final isSelected =
                  cubit.filterCategory?.categoryName == category.categoryName;

              return GestureDetector(
                onTap: () => cubit.selectFilterCategory(category, index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.primaryBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: commonTitle(
                    title: category.categoryName,
                    color: isSelected ? AppColors.white : AppColors.grey,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
