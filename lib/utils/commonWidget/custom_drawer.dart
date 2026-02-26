import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:paw_pal_admin/core/AppColors.dart';
import 'package:paw_pal_admin/core/AppImages.dart';
import 'package:paw_pal_admin/core/CommonMethods.dart';
import 'package:paw_pal_admin/routes/routes.dart';
import 'package:paw_pal_admin/utils/widget_helper.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = CommonMethods.getCurrentUser();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Drawer(
          backgroundColor: AppColors.white,
          child: RepaintBoundary(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        RepaintBoundary(
                          child: SvgPicture.asset(AppImages.icPaw, height: 60, width: 60),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonTitle(
                              title: "Admin",
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            commonTitle(
                              title: user?.email ?? "",
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            
                  drawerItem(
                    context,
                    title: "Videos",
                    route: Routes.videoScreen,
                  ),
                  drawerItem(context, title: "Manage User", route: ""),
                  drawerItem(context, title: "Manage Faq's", route: Routes.faqScreen),
                  drawerItem(context, title: "Product Category", route: Routes.productCategoryScreen),
                  drawerItem(context, title: "Product Management", route: Routes.createProductScreen),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 19.0,
                      vertical: 15,
                    ),
                    child: InkResponse(
                      onTap: () {
                        CommonMethods.firebaseLogOut(context);
                      },
                      child: commonTitle(
                        title: "Log Out",
                        color: AppColors.primaryColor,
                        fontSize: 17,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          top: 65,
          right: -18,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget drawerItem(
    BuildContext context, {
    required String title,
    required String route,
    Color color = Colors.black,
  }) {
    return InkResponse(
      onTap: () {
        _navigate(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0,vertical: 15),
        child: commonTitle(
          title: title,
          fontWeight: FontWeight.w600,
          fontSize: 17,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.pushNamed(route);
  }
}
