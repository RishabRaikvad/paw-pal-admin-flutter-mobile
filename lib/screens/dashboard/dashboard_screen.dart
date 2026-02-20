import 'package:flutter/material.dart';
import 'package:paw_pal_admin/core/AppColors.dart';

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
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),


      body: SafeArea(child: mainView()),
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
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
