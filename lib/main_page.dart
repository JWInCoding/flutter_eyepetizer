import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/module/category/category_page.dart';
import 'package:flutter_eyepetizer/module/daily/daily_page.dart';
import 'package:flutter_eyepetizer/module/follow/follow_page.dart';
import 'package:flutter_eyepetizer/module/hot/hot_page.dart';

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
    const HotPage(),
    const CategoryPage(),
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
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: '热门',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: '分类',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_outlined),
              activeIcon: Icon(Icons.subscriptions),
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
