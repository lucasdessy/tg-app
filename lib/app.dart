import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_platform_app/application/auth/auth_cubit.dart';
import 'package:sales_platform_app/injection.dart';
import 'package:sales_platform_app/presentation/app/router.dart';
import 'package:sales_platform_app/presentation/shared/config.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(SharedConfigs.colors.brightness),
        onGenerateRoute: getIt<AppRouter>().onGenerateRoute,
        initialRoute: AppRoutes.splash.path,
      ),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  var baseTheme = ThemeData(brightness: brightness);
  SystemChrome.setSystemUIOverlayStyle(
    brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark,
  );

  return baseTheme.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: SharedConfigs.colors.secondary,
      brightness: brightness,
    ),
    canvasColor: SharedConfigs.colors.tertiary,
    scaffoldBackgroundColor: SharedConfigs.colors.primary,
    cardColor: SharedConfigs.colors.tertiary,
    dialogTheme: baseTheme.dialogTheme.copyWith(
      contentTextStyle: TextStyle(color: SharedConfigs.colors.neutral),
      alignment: Alignment.center,
    ),
    buttonTheme: baseTheme.buttonTheme.copyWith(
      buttonColor: SharedConfigs.colors.secondary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    appBarTheme: baseTheme.appBarTheme.copyWith(
        color: SharedConfigs.colors.tertiary,
        elevation: 0.0,
        iconTheme: IconThemeData(color: SharedConfigs.colors.neutral),
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: SharedConfigs.colors.neutral),
        centerTitle: true),
    textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    // Color of outline border when TextField is focused
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: SharedConfigs.colors.secondary),
        borderRadius: BorderRadius.circular(16.0),
      ),
      // Color of outline border when TextField is not focused.
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: SharedConfigs.colors.neutral),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SharedConfigs.colors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          color: SharedConfigs.colors.neutral,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: SharedConfigs.colors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
