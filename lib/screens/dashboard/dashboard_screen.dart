import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paw_pal_admin/core/AppColors.dart';
import 'package:paw_pal_admin/core/AppImages.dart';
import 'package:paw_pal_admin/utils/commonWidget/gradient_background.dart';
import 'package:paw_pal_admin/utils/widget_helper.dart';

import '../../utils/commonWidget/custom_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.linearBg,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        drawer: Drawer(
          backgroundColor: Colors.transparent,
          child: const CustomDrawer(),
        ),
        body: SafeArea(
          child: mainView(),
        ),
      ),
    );
  }

  Widget mainView(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const  SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child:Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(AppImages.icDrawer),
                  ],
                ),
                Center(
                  child: commonTitle(
                    title: "Dashboard",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget dashBoardCardView(){
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(),
    );
  }
}
