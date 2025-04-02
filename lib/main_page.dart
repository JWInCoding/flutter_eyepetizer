import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_eyepetizer/common/utils/toast_utils.dart';
import 'package:flutter_eyepetizer/module/daily/daily_page.dart';
import 'package:flutter_eyepetizer/module/discovery/discovery_page.dart';
import 'package:flutter_eyepetizer/module/hot/hot_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItemIndex = 0;

  DateTime? _lastBackPressTime; // 添加变量跟踪上次点击返回的时间
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const DailyPage(),
    const DiscoveryPage(),
    const HotPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handlePopInvoked,
      child: Scaffold(
        body: PageView.builder(
          itemBuilder: (context, index) {
            return _pages[index];
          },
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          controller: _pageController,
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 24,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _selectedItemIndex,
          onTap: _onNavItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '日报',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: '发现',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: '热门',
            ),
          ],
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void _handlePopInvoked(bool didPop, dynamic result) {
    if (didPop) {
      return;
    }

    final now = DateTime.now();

    // 判断是否是在短时间内（2秒）连续点击
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      // 第一次点击或者两次点击间隔超过2秒
      _lastBackPressTime = now;

      showTip('再按一次返回键退出应用');
    } else {
      SystemNavigator.pop(); // 退出应用
    }
  }
}
