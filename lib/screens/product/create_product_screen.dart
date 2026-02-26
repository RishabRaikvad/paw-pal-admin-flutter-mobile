import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/bloc/productBloc/product_cubit.dart';
import 'package:paw_pal_admin/bloc/productCategoryBloc/product_category_cubit.dart';
import 'package:paw_pal_admin/core/AppImages.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/core/constant.dart';
import 'package:paw_pal_admin/routes/routes.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_admin/utils/dialog_utils.dart';

import '../../core/AppColors.dart';
import '../../core/AppStrings.dart';
import '../../utils/widget_helper.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  late ProductCategoryCubit categoryCubit;
  late ProductCubit cubit;

  @override
  void initState() {
    super.initState();
    categoryCubit = context.read<ProductCategoryCubit>();
    cubit = context.read<ProductCubit>();
    cubit.resetLocalData();
    categoryCubit.getProductCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            return mainView();
          },
        ),
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

            commonBackWithHeader(context: context, title: "Add Products"),

            const SizedBox(height: 20),

            commonTitle(
              title: "Create New Product",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 4),

            commonTitle(
              title:
                  "Add product details, images, and pricing to publish it in your store.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),

            const SizedBox(height: 30),
            Flexible(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: productBasicInfoView()),
                  SliverToBoxAdapter(child: const SizedBox(height: 20)),
                  SliverToBoxAdapter(child: commonDottedLine()),
                  SliverToBoxAdapter(child: const SizedBox(height: 20)),
                  SliverToBoxAdapter(child: productImagesView()),
                  SliverToBoxAdapter(child: const SizedBox(height: 30)),
                  if (cubit.selectedCategory?.variantType != VariantType.none &&
                      cubit.selectedCategory != null) ...[
                    SliverToBoxAdapter(child: commonDottedLine()),
                    SliverToBoxAdapter(child: const SizedBox(height: 20)),
                    SliverToBoxAdapter(child: pricingAndVariantsView()),
                    SliverToBoxAdapter(child: const SizedBox(height: 20)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productBasicInfoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Product Basic Information",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 10),
        commonTitle(
          title: "Select Category",
          fontSize: 16,
          color: AppColors.grey,
        ),
        const SizedBox(height: 8),
        InkResponse(
          onTap: categoryBottomSheet,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.inputBgColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonTitle(
                    title:
                        cubit.selectedCategory?.categoryName ??
                        "Select Category",
                    fontSize: 16,
                    color: AppColors.plashHolderColor,
                  ),
                  Icon(Icons.keyboard_arrow_down_sharp),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        commonTextFieldWithLabel(
          label: "Product Name",
          hint: "Enter Product Name",
          context: context,
          controller: cubit.productNameController,
        ),
        const SizedBox(height: 20),
        commonTextFieldWithLabel(
          label: "Product Description",
          hint: "Write a short product description.....",
          context: context,
          controller: cubit.productDescriptionController,
          maxLines: 4,
          maxLength: 200,
        ),
      ],
    );
  }

  Widget productImagesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Product Images",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 10),
        uploadMainPetImageView(),
        const SizedBox(height: 10),
        uploadProductOtherImgView(),
      ],
    );
  }

  Widget uploadMainPetImageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(title: AppStrings.uploadMainImage),
        const SizedBox(height: 10),
        uploadImageView(
          context: context,
          uploadedImage: cubit.productMainImageNotifier,
          image: AppImages.icMainPet,
          height: 200,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget uploadProductOtherImgView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        const itemCount = 4;

        final totalSpacing = spacing * (itemCount - 1);
        final itemSize = (constraints.maxWidth - totalSpacing) / itemCount;

        return Row(
          children: List.generate(itemCount, (index) {
            final notifier = [
              cubit.productOtherImage1Notifier,
              cubit.productOtherImage2Notifier,
              cubit.productOtherImage3Notifier,
              cubit.productOtherImage4Notifier,
            ][index];

            return Padding(
              padding: EdgeInsets.only(
                right: index == itemCount - 1 ? 0 : spacing,
              ),
              child: SizedBox(
                width: itemSize,
                height: itemSize,
                child: uploadImageView(
                  context: context,
                  uploadedImage: notifier,
                  image: AppImages.icPetOther,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget pricingAndVariantsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTitle(
          title: "Product Pricing & Variants",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 10),
        commonTitle(title: "Variants", fontSize: 16, color: AppColors.grey),
        const SizedBox(height: 15),
        if (cubit.lstProductVariant.isNotEmpty) ...[
          variantView(),
          const SizedBox(height: 10),
        ],
        GestureDetector(
          onTap: addVariantPricingBottomSheet,
          child: SvgPicture.asset(AppImages.icAddVariantBtn),
        ),
      ],
    );
  }

  Widget variantView() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(cubit.lstProductVariant.length, (index) {
        final variant = cubit.lstProductVariant[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.variantColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${variant.title} - ",
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),
                    ),
                    TextSpan(
                      text: CommonMethods.formatPrice(variant.price),
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  cubit.removeVariant(index);
                },
                child: const Icon(
                  Icons.delete,
                  size: 18,
                  color: AppColors.redColor,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void categoryBottomSheet() {
    DialogUtils.openBottomSheetDialog(
      context: context,
      isScrollControlled: true,
      contentWidget: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            commonTitle(
              title: "Choose Category",
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 4),

            commonTitle(
              title:
                  "Choose the most relevant category for this product. You can also create a new one if needed.",
              fontSize: 16,
              color: AppColors.grey,
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
                builder: (context, state) {
                  return CustomScrollView(
                    slivers: [
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          return categoryGridView();
                        },
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 50)),
                      SliverToBoxAdapter(child: bottomSheetBtnView()),
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

  void addVariantPricingBottomSheet() {
    cubit.productVariantController.clear();
    cubit.productVariantPriceController.clear();
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
                    const SizedBox(height: 20),

                    commonTitle(
                      title: "Add Variant Pricing",
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: 4),

                    commonTitle(
                      title:
                      "Enter the variant value and set its price for this product.",
                      fontSize: 16,
                      color: AppColors.grey,
                      textAlign: TextAlign.start
                    ),

                    const SizedBox(height: 20),

                    /// Variant Type
                    commonTitle(
                      title: "Variant Type",
                      fontSize: 16,
                      color: AppColors.grey,
                    ),

                    const SizedBox(height: 8),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBgColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          commonTitle(
                            title:
                            cubit.selectedCategory?.variantType.name ?? "",
                            fontSize: 16,
                            color: AppColors.plashHolderColor,
                          ),
                          const Icon(Icons.keyboard_arrow_down_sharp),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    commonTitle(
                      title:
                      "This Variant type is Fixed and cannot be changed.",
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppColors.primaryColor,
                    ),

                    const SizedBox(height: 20),

                    /// Variant Value
                    commonTextFieldWithLabel(
                      label: "Variant Value",
                      hint: "Enter Variant Value",
                      context: context,
                      controller: cubit.productVariantController,
                    ),

                    const SizedBox(height: 20),

                    /// Variant Price
                    commonTextFieldWithLabel(
                      label: "Variant Price",
                      hint: "Enter Price",
                      context: context,
                      controller: cubit.productVariantPriceController,
                      inputType: TextInputType.number
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Flexible(
                          child: commonOutLineButtonView(
                            context: context,
                            buttonText: "Cancel",
                            onClicked: () => context.pop(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: commonButtonView(
                            context: context,
                            buttonText: "Add",
                            onClicked: () {
                             if(cubit.productVariantController.text.isEmpty){
                               CommonMethods().showErrorToast("Please Enter Value");
                               return;
                             }else if(cubit.productVariantPriceController.text.isEmpty){
                               CommonMethods().showErrorToast("Please Enter Price");
                               return;
                             }else {
                               cubit.addVariant();
                               context.pop();
                             }
                            }
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  SliverGrid categoryGridView() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == categoryCubit.lstCategory.length) {
          return addCategoryTile();
        }
        final category = categoryCubit.lstCategory[index];

        return GestureDetector(
          onTap: () {
            cubit.setCategoryIndex(index);
          },
          child: categoryView(
            imgUrl: category.image,
            categoryName: category.categoryName,
            isSelected: cubit.selectedCategoryIndex == index,
          ),
        );
      }, childCount: categoryCubit.lstCategory.length + 1),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.88,
      ),
    );
  }

  Widget bottomSheetBtnView() {
    return Row(
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
            buttonText: "Confirm Category",

            onClicked: () {
              if (cubit.selectedCategoryIndex != null) {
                final isSelected = categoryCubit
                    .lstCategory[cubit.selectedCategoryIndex ?? -1];
                cubit.getSelectedCategory(isSelected);
                context.pop();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget categoryView({
    required String imgUrl,
    required String categoryName,
    bool isSelected = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor.withValues(alpha: 0.2)
            : AppColors.dividerColor.withValues(alpha: 0.7),
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
              color: isSelected ? AppColors.primaryColor : AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget addCategoryTile() {
    return InkResponse(
      onTap: () {
        context.pushNamed(Routes.createProductCategoryScreen);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.dividerColor.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            children: [
              SvgPicture.asset(AppImages.icAddCategory),
              const SizedBox(height: 8),
              commonTitle(
                title: "Add Category",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
