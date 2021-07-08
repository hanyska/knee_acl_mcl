import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/utils/utils.dart';

PreferredSizeWidget myAppBar({String? title, List<Widget>? actions, double? elevation, TabBar? tabBar}) {
  return AppBar(
      elevation: elevation ?? 4.0,
      iconTheme: IconThemeData(color: kWhite),
      backgroundColor: kPrimaryColor,
      title: title != null
        ? Text(title, style: TextStyle(color: kWhite))
        : null,
      bottom: tabBar == null ? null : TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
        indicatorColor: kWhite,
        labelColor: kWhite,
        unselectedLabelColor: kLightGrey,
        controller: tabBar.controller,
        tabs: List<Tab>.from(tabBar.tabs).map<Tab>((Tab tab) => Tab(text: tab.text!.toUpperCase())).toList(),
        onTap: tabBar.onTap,
      ),
      actions: actions
  );
}