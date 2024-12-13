import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../utils/language_manager.dart';
import '../app_bar/appbar_widget.dart';

class ScaffoldWithoutNestedNavigation extends StatelessWidget {
  const ScaffoldWithoutNestedNavigation(
      {super.key, required this.navigationShell});

  final Widget navigationShell;

  @override
  Widget build(BuildContext context) {
    return navigationShell;
  }
}

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation(
      {Key? key, required this.navigationShell, required this.uri})
      : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;
  final String uri;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          pageName: uri.split('/').last,
          onDestinationSelected: _goBranch,
        );
      } else {
        return ScaffoldWithNavigationRail(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
    });
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.pageName,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final String pageName;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> appBarTitle = {
      "GoldPricePage": AppStrings.strGoldPricePage.tr(context),
      "SettingsPage": AppStrings.strSettingsPage.tr(context)
    };

    return Scaffold(
      body: body,
      appBar: appBarTitle.containsKey(pageName)
          ? MyAppBar(title: appBarTitle[pageName]!)
          : null,
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: Colors.green,
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(
            label: AppStrings.strHomePage.tr(context),
            icon: const Icon(Icons.home_rounded),
            selectedIcon: const Icon(
              Icons.home_outlined,
              color: Colors.green,
            ),
          ),
          NavigationDestination(
            label: AppStrings.strGoldPricePage.tr(context),
            icon: const Icon(Icons.timeline_rounded),
            selectedIcon: const Icon(
              Icons.insights_rounded,
              color: Colors.green,
            ),
          ),
          NavigationDestination(
            label: AppStrings.strContactPage.tr(context),
            icon: const Icon(Icons.contact_phone_rounded),
            selectedIcon: const Icon(
              Icons.contact_phone_outlined,
              color: Colors.green,
            ),
          ),
          NavigationDestination(
            label: AppStrings.strSettingsPage.tr(context),
            icon: const Icon(Icons.manage_accounts_rounded),
            selectedIcon: const Icon(
              Icons.manage_accounts_rounded,
              color: Colors.green,
            ),
          ),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            selectedIconTheme: const IconThemeData(
              color: Colors.green,
            ),
            selectedLabelTextStyle: TextStyle(
              color: Colors.green,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.8,
              decorationThickness: 2.0,
            ),
            unselectedLabelTextStyle: TextStyle(
              fontSize: 10.sp,
              letterSpacing: 0.8,
            ),
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                label: Text(
                  AppStrings.strHomePage.tr(context),
                ),
                icon: Icon(
                  Icons.home_rounded,
                  size: 15.sp,
                ),
              ),
              NavigationRailDestination(
                label: Text(AppStrings.strGoldPricePage.tr(context)),
                icon: Icon(
                  Icons.timeline_rounded,
                  size: 15.sp,
                ),
              ),
              NavigationRailDestination(
                label: Text(AppStrings.strContactPage.tr(context)),
                icon: Icon(
                  Icons.person_pin_rounded,
                  size: 15.sp,
                ),
              ),
              NavigationRailDestination(
                label: Text(AppStrings.strSettingsPage.tr(context)),
                icon: Icon(
                  Icons.manage_accounts_rounded,
                  size: 15.sp,
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
