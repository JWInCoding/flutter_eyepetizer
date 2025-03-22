import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/module/daily/daily_page.dart';
import 'package:flutter_eyepetizer/module/discover/discover_page.dart';
import 'package:flutter_eyepetizer/module/follow/follow_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItemIndex = 0;

  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const DailyPage(),
    const DiscoverPage(),
    const FollowPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
              icon: Icon(Icons.follow_the_signs_outlined),
              activeIcon: Icon(Icons.follow_the_signs),
              label: '关注',
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
}
