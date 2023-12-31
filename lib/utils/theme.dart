import 'package:flutter/material.dart';

Color appBackgroundColor = Color.fromARGB(255, 242, 255, 246);
Color appOnBackgroundColor = Color.fromARGB(255, 145, 196, 165);
Color appPrimaryColor = Color.fromARGB(255, 122, 199, 147);
Color appOnPrimaryColor = Color.fromARGB(255, 248, 255, 251);
Color appIncomeButtonColor = Color.fromARGB(255, 112, 214, 151);
Color appExpenseButtonColor = Color.fromARGB(255, 245, 131, 130);
Color appWhenPositiveBalanceColor = appPrimaryColor;
Color appWhenEmptyPieChartColor = Color.fromARGB(255, 173, 182, 177);

OutlinedBorder appRoundedMaterialStyle = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(7.0),
);

ButtonStyle appRoundedButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all(
    appRoundedMaterialStyle,
  ),
);

var appThemeData = ThemeData(
  useMaterial3: true,
  // For Flutter M3, the AppBar.backgroundColor uses the ColorScheme.surface by default.
  // We override this here.
  appBarTheme: AppBarTheme(
    backgroundColor: appPrimaryColor,
    foregroundColor: appOnPrimaryColor,
    titleTextStyle: TextStyle(
      fontSize: 18,
    ),
  ),

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange,
    // TRY THIS: Change to "Brightness.light"
    //           and see that all colors change
    //           to better contrast a light background.
    brightness: Brightness.dark,
  ).copyWith(
    background: appBackgroundColor,
    onBackground: appOnBackgroundColor,

    surface: appBackgroundColor,
    onSurface: appOnBackgroundColor,

    // [Text] within a [OutlinedButton] will use this color by default
    primary: appPrimaryColor,
    onPrimary: appOnPrimaryColor,
    primaryContainer: appPrimaryColor,
    onPrimaryContainer: appOnPrimaryColor,

    secondary: Colors.cyan,
    onSecondary: Colors.red,
    tertiary: Colors.pink,
    onTertiary: Colors.purple,

    shadow: Colors.pink,
  ),

  // Define the default `TextTheme`. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 72,
      fontWeight: FontWeight.bold,
    ),
    // TRY THIS: Change one of the GoogleFonts
    //           to "lato", "poppins", or "lora".
    //           The title uses "titleLarge"
    //           and the middle text uses "bodyMedium".
  ),

  cardTheme: CardTheme(
    shape: appRoundedMaterialStyle,
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: appRoundedButtonStyle.merge(
      ButtonStyle(
          // Add more if needed
          ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: appRoundedButtonStyle.merge(
      ButtonStyle(
          // Add more if needed
          ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: appRoundedButtonStyle.merge(
      ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(appBackgroundColor),
        foregroundColor: MaterialStatePropertyAll(Colors.grey),
      ),
    ),
  ),
  extensions: <ThemeExtension<dynamic>>[
    AppExtraColors(
      incomeColor: appIncomeButtonColor,
      expenseColor: appExpenseButtonColor,
      onIncomeColor: Colors.white,
      onExpenseColor: Colors.white,
    ),
  ],
);

@immutable
class AppExtraColors extends ThemeExtension<AppExtraColors> {
  const AppExtraColors({
    required this.incomeColor,
    required this.onIncomeColor,
    required this.expenseColor,
    required this.onExpenseColor,
  });

  final Color incomeColor;
  final Color onIncomeColor;
  final Color expenseColor;
  final Color onExpenseColor;

  @override
  AppExtraColors copyWith({
    Color? incomeColor,
    Color? expenseColor,
    Color? onIncomeColor,
    Color? onExpenseColor,
  }) {
    return AppExtraColors(
      incomeColor: incomeColor ?? this.incomeColor,
      onIncomeColor: onIncomeColor ?? this.onIncomeColor,
      expenseColor: expenseColor ?? this.expenseColor,
      onExpenseColor: onExpenseColor ?? this.onExpenseColor,
    );
  }

  @override
  AppExtraColors lerp(AppExtraColors? other, double t) {
    if (other is! AppExtraColors) {
      return this;
    }
    return AppExtraColors(
      incomeColor: Color.lerp(incomeColor, other.incomeColor, t)!,
      onIncomeColor: Color.lerp(onIncomeColor, other.onIncomeColor, t)!,
      expenseColor: Color.lerp(expenseColor, other.expenseColor, t)!,
      onExpenseColor: Color.lerp(onExpenseColor, other.onExpenseColor, t)!,
    );
  }

  // Optional
  @override
  String toString() =>
      'MyColors(brandColor: $incomeColor, danger: $expenseColor)';
}
