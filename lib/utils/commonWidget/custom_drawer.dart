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
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SvgPicture.asset(
                          AppImages.icAppIconPlaceholder,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      const SizedBox(width: 12),
                      commonTitle(
                        title: user?.email ?? "",
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),

                drawerItem(context, title: "Add Pet Care Video", route: Routes.addVideoScreen),
                const SizedBox(width: 30),
                drawerItem(context, title: "Feedback", route: ""),
                const SizedBox(width: 30),
                drawerItem(
                  context,
                  title: "Terms & Conditions",
                  route: "",
                ),
                const SizedBox(width: 30),
                drawerItem(context, title: "Privacy Policy", route: ""),
                const SizedBox(width: 30),
                drawerItem(context, title: "Contact Us", route: ""),
                const SizedBox(width: 30),
                drawerItem(context, title: "Share App", route: ""),
                const SizedBox(width: 30),
                drawerItem(context, title: "Delete Account", route: ""),
                const SizedBox(width: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 19.0,
                    vertical: 18,
                  ),
                  child: InkResponse(
                    onTap: () {
                      CommonMethods.firebaseLogOut(context);
                    },
                    child: commonTitle(
                      title: "Log Out",
                      color: AppColors.redColor,
                      fontSize: 16,
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

        Positioned(
          top: 65,
          right: -18,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: AppColors.drawerArrowColor,
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
    return ListTile(
      title: commonTitle(
        title: title,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        textAlign: TextAlign.start,
      ),
      onTap: () {
         _navigate(context, route);
      },
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.pushNamed(route);
  }
}
