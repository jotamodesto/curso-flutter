import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'models/meal.dart';
import 'models/settings.dart';
import 'data/dummy_data.dart';
import 'screens/tabs_screen.dart';
import 'screens/categories_meals_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeData = ThemeData(fontFamily: 'Raleway');
  Settings settings = Settings();
  List<Meal> _availableMeals = dummyMeals;
  final List<Meal> _favoriteMeals = [];

  void _filterMeals(Settings settings) {
    setState(() {
      this.settings = settings;

      _availableMeals = dummyMeals.where((meal) {
        final filterGluten = settings.isGlutenFree && !meal.isGlutenFree;
        final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
        final filterVegan = settings.isVegan && !meal.isVegan;
        final filterVegetarian = settings.isVegetarian && !meal.isVegetarian;

        return !filterGluten &&
            !filterLactose &&
            !filterVegan &&
            !filterVegetarian;
      }).toList();
    });
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: themeData.copyWith(
        scaffoldBackgroundColor: const Color.fromRGBO(255, 254, 229, 1),
        colorScheme: themeData.colorScheme.copyWith(
          primary: Colors.pink,
          secondary: Colors.amber,
        ),
        appBarTheme: themeData.appBarTheme.copyWith(
          titleTextStyle: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
          ),
        ),
        textTheme: themeData.textTheme.copyWith(
          titleLarge: themeData.textTheme.titleLarge!.copyWith(
            fontFamily: 'RobotoCondensed',
            fontSize: 20,
          ),
        ),
      ),
      routes: {
        AppRoutes.home: (_) => TabsScreen(favoriteMeals: _favoriteMeals),
        AppRoutes.categoriesMeals: (_) =>
            CategoriesMealsScreen(meals: _availableMeals),
        AppRoutes.mealDetail: (_) => MealDetailScreen(
            onToggleFavorite: _toggleFavorite, isFavorite: _isFavorite),
        AppRoutes.settings: (_) => SettingsScreen(
              onSettingsChanged: _filterMeals,
              settings: settings,
            ),
      },
    );
  }
}
