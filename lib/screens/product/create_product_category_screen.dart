import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';

import '../../bloc/productCategoryBloc/product_category_cubit.dart';
import '../../core/AppColors.dart';
import '../../core/AppImages.dart';
import '../../core/CommonMethods.dart';
import '../../core/constant.dart';
import '../../utils/widget_helper.dart';

class CreateProductCategoryScreen extends StatefulWidget {
  const CreateProductCategoryScreen({super.key});

  @override
  State<CreateProductCategoryScreen> createState() =>
      _CreateProductCategoryScreenState();
}

class _CreateProductCategoryScreenState
    extends State<CreateProductCategoryScreen> {
  late ProductCategoryCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProductCategoryCubit>();
    cubit.resetLocalData();
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

            commonBackWithHeader(context: context, title: "Product Category"),

            const SizedBox(height: 20),

            /// Title
            commonTitle(
              title: "Create New Category",
              fontSize: 22,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 4),

            commonTitle(
              title: "Define category and how product variants will behave.",
              fontSize: 16,
              textAlign: TextAlign.start,
              color: AppColors.grey,
            ),

            const SizedBox(height: 30),
            Flexible(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: uploadCategoryFormView()),
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

  Widget uploadCategoryImageView() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final image = await CommonMethods.pickAndCompressImage(
                context: context,
              );

              if (image != null) {
                cubit.categoryImageNotifier.value = image;
              }
            },
            child: ValueListenableBuilder<File?>(
              valueListenable: cubit.categoryImageNotifier,
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
          const SizedBox(height: 12),
          commonTitle(title: "Upload Category Image", color: AppColors.grey),
        ],
      ),
    );
  }

  Widget uploadCategoryFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        uploadCategoryImageView(),

        const SizedBox(height: 30),

        commonTextFieldWithLabel(
          label: "Category Name",
          hint: "Ex: Pet Food, Clothes, Toys",
          context: context,
          controller: cubit.categoryNameController,
        ),

        const SizedBox(height: 20),

        commonTitle(
          title: "Variant Type",
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.grey,
        ),

        const SizedBox(height: 8),

        BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.inputBgColor.withValues(alpha: 0.1),
              ),
              child: DropdownButton<VariantType>(
                value: cubit.selectedVariantType,
                isExpanded: true,
                underline: const SizedBox(),
                items: VariantType.values.map((type) {
                  return DropdownMenuItem<VariantType>(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    cubit.updateVariantType(value);
                  }
                },
              ),
            );
          },
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget buildUploadBtn() {
    return BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
      builder: (context, state) {
        final isLoading = state is UploadCategoryLoadingState;
        return commonButtonView(
          context: context,
          buttonText: "Publish Category",
          onClicked: () {
            if (cubit.isValidCategory()) {
              cubit.createCategory(context);
            }
          },
          isLoading: isLoading,
        );
      },
    );
  }
}
