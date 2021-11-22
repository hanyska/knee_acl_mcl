import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:knee_acl_mcl/calendar_page.dart';
import 'package:knee_acl_mcl/home_page.dart';
import 'package:knee_acl_mcl/profile_page.dart';
import 'package:knee_acl_mcl/utils/utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({Key? key}) : super(key: key);

  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  bool _hideNavBar = false;

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      CalendarPage(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: tr('button.home'),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_today),
        title: tr('button.progress'),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: tr('button.profile'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView.custom(
      context,
      controller: _controller,
      screens: _buildScreens(),
      confineInSafeArea: true,
      itemCount: _buildScreens().length,
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      hideNavigationBar: _hideNavBar,
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      customWidget: CustomNavBarWidget(
        items: _navBarsItems(),
        onItemSelected: (index) => setState(() => _controller.index = index),
        selectedIndex: _controller.index,
      ),
    );
  }
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  CustomNavBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    Color _color = isSelected ? kPrimaryColor : kLightGrey;
    return Container(
      alignment: Alignment.center,
      height: kBottomNavigationBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(size: 26.0, color: _color),
              child: item.icon
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              item.title.toString(),
              style: TextStyle(
                color: _color,
                fontWeight: FontWeight.w400,
                fontSize: 12.0
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: kBottomNavigationBarHeight,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          int index = items.indexOf(item);
          return Flexible(
            child: GestureDetector(
              onTap: () => this.onItemSelected(index),
              child: _buildItem(item, selectedIndex == index),
            ),
          );
        }).toList(),
      ),
    );
  }
}
