import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/config/string.dart';
import 'package:flutter_eyepetizer/module/discover_page.dart';
import 'package:flutter_eyepetizer/module/home_page.dart';
import 'package:flutter_eyepetizer/module/mine_page.dart';
import 'package:flutter_eyepetizer/module/rank_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItemIndex = 0;

  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(dailyPaper),
    const DiscoverPage(discover),
    const RankPage(hot),
    const MinePage(mine),
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
          selectedItemColor: Colors.black,
          unselectedFontSize: 14,
          currentIndex: _selectedItemIndex,
          onTap: _onNavItemTapped,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: dailyPaper,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: discover,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline_outlined),
              activeIcon: Icon(Icons.bookmark),
              label: hot,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: mine,
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
