import 'package:units_converter/units_converter.dart';

const String appName = 'Recipes';
const String appLogo = '';
const String camera = "Camera";
const String gallery = "Gallery";
const String logoPlaceholder = 'assets/images/placeholder.png';
const String emptyListImage = 'assets/images/emptyList.png';
const String editPageTitle = 'Edit Recipe';
const String invalidData = 'Invalid Data';
const String emptyList = 'Empty List';
const int maxIngredients = 30;
const int maxSteps = 10;

final List<Unit> units = [
  NumeralSystems().decimal,
  Mass().milligrams,
  Mass().grams,
  Mass().kilograms,
  Mass().ounces,
  Mass().pounds,
  Volume().tablespoonsUs,
  Volume().cups,
  Volume().liters,
];
