import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'constants/app_routes.dart';
import 'constants/colors.dart';

// Screens
import 'screens/onboarding/intro_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/medical/medical_history_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/favourite/favourite_screen.dart';
import 'screens/cart/track_order_screen.dart';
import 'screens/explore/explore_screen.dart';
import 'screens/profile/account_screen.dart';
import 'widgets/common/main_app_screen.dart';

// Providers
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/tab_index_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => TabIndexProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOUQÉ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textDark,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const IntroScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.signin: (context) => const SignInScreen(),
        AppRoutes.signup: (context) => const SignUpScreen(),
        AppRoutes.login: (context) => const LogInScreen(),
        AppRoutes.home: (context) => const MainAppScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRoutes.medicalHistory: (context) => const MedicalHistoryScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
        AppRoutes.explore: (context) => const ExploreScreen(),
        AppRoutes.trackOrder: (context) => const TrackOrderScreen(),
        AppRoutes.account: (context) => const AccountScreen(),
        AppRoutes.favorite: (context) => const FavoritesScreen(),
      },
    );
  }
}