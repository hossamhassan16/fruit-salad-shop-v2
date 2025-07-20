import 'package:flutter/material.dart';
import 'package:fruite_salad_shop/widgets/hottest_tab.dart';
import 'package:fruite_salad_shop/widgets/new_combo_tab.dart';
import 'package:fruite_salad_shop/widgets/popular_tab.dart';
import 'package:fruite_salad_shop/widgets/top_tab.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({super.key});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final tabs = ["Hottest", "Popular", "New", "Top"];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          isScrollable: false,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepOrange,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          tabs: tabs.map((title) => Tab(text: title)).toList(),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              HottestTab(),
              PopularTab(),
              NewComboTab(),
              TopTab(),
            ],
          ),
        ),
      ],
    );
  }
}
