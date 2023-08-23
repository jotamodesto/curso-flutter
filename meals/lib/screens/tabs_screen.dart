import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../components/main_drawer.dart';
import 'categories_screen.dart';
import 'favorite_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({required this.favoriteMeals, super.key});

  final List<Meal> favoriteMeals;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedScreenIndex = 0;
  final List<String> _screens = ['Categorias', 'Meus Favoritos'];

  _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_screens[_selectedScreenIndex]),
        ),
        drawer: const MainDrawer(),
        body: TabBarView(
          children: [
            const CategoriesScreen(),
            FavoriteScreen(
              favoriteMeals: widget.favoriteMeals,
            ),
          ],
        ),
        bottomNavigationBar: Material(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TabBar(
              onTap: _selectScreen,
              indicatorColor: Colors.transparent,
              labelColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelColor: Colors.white,
              tabs: const [
                Tab(
                  icon: Icon(Icons.category),
                  text: 'Categorias',
                ),
                Tab(
                  icon: Icon(Icons.star),
                  text: 'Favoritos',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
