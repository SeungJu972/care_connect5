import 'package:flutter/material.dart';

//탭바 정보를 저장하는 메뉴
class TabInfo {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;

  const TabInfo({
    required this.selectedIcon,
    required this.label,
    required this.unselectedIcon,
  });
}

final TABS = [
  const TabInfo(
    selectedIcon: Icons.home,
    unselectedIcon: Icons.home_outlined,
    label: 'Home',
  ),
  const TabInfo(
    selectedIcon: Icons.route,
    label: 'Routh',
    unselectedIcon: Icons.route_outlined,
  ),
  const TabInfo(
    selectedIcon: Icons.monitor_heart,
    label: 'Health',
    unselectedIcon: Icons.monitor_heart_outlined,
  ),
];
