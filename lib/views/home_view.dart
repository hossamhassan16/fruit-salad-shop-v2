import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fruite_salad_shop/utils/app_images.dart';
import 'package:fruite_salad_shop/utils/styles.dart';
import 'package:fruite_salad_shop/widgets/basket_widget.dart';
import 'package:fruite_salad_shop/widgets/custom_search_bar.dart';
import 'package:fruite_salad_shop/widgets/favorite_page.dart';
import 'package:fruite_salad_shop/widgets/home_tab_bar.dart';
import 'package:fruite_salad_shop/widgets/my_basket_page.dart';
import 'package:fruite_salad_shop/widgets/recommended_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.name});
  final String name;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  String searchQuery = '';
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.2,
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(Assets.imagesBars),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MyBasketPage(clientName: widget.name),
                          ),
                        );
                      },
                      child: BasketWidget(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Greeting
              Text(
                "Hello ${widget.name}, What fruit salad combo do you want today?",
                style: Styles.style20medium,
              ),

              const SizedBox(height: 28),

              // Search and Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: CustomSearchBar(onChanged: updateSearch)),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoritePage()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Recommended Section
              Text("Recommended Combo", style: Styles.style24medium),
              const SizedBox(height: 32),

              // Recommended List
              RecommendedListView(
                searchQuery: searchQuery,
              ),

              const HomeTabBar(),
            ],
          ),
        ),
      ),
    );
  }
}
