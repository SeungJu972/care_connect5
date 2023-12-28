import 'package:care_connect/const/tabs.dart';
import 'package:care_connect/screen/home/taps/health_screen.dart';
import 'package:care_connect/screen/home/taps/map_screen.dart';
import 'package:care_connect/screen/home/taps/route_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String username;
  final String password;

  MainScreen({
    required this.username,
    required this.password,
    Key? key,
  }) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  //탭바 컨트롤러 선언
  late final TabController controller;

  @override
  void initState() {
    super.initState();

    //컨트롤러 초기화
    controller = TabController(length: TABS.length, vsync: this);

    //컨트롤러 상태를 읽는 함수
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //선택된 탭을 보여주는 부분
      body: TabBarView(
        controller: controller,
        children:  [
          MapScreen(username:widget.username,password: widget.username,),
          RouteScreen( username:widget.username,password: widget.username,),
          HealthScreen(username:widget.username,password: widget.username,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //탭 컬ㅓ
        selectedItemColor: Colors.green[900],
        unselectedItemColor: Colors.green[300],
        selectedIconTheme: const IconThemeData(size: 25),

        //label 보여줄지 말지
        showSelectedLabels: true,
        showUnselectedLabels: true,

        //탭 확대 삭제
        type: BottomNavigationBarType.fixed,

        //현재 인덱스
        currentIndex: controller.index,
        onTap: (index) {
          controller.animateTo(index);
        },
        items: TABS
            .asMap()
            .entries
            .map(
              (entry) => BottomNavigationBarItem(
                icon: Icon(
                  entry.key == controller.index
                      ? entry.value.selectedIcon
                      : entry.value.unselectedIcon,
                ),
                label: entry.value.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
