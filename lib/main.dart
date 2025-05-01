import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Constants
import 'constants/app_routes.dart';
import 'constants/colors.dart';

// Screens
import 'screens/onboarding/intro_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/cart/order_status_screen.dart';
import 'screens/cart/track_order_screen.dart';
import 'screens/medical/medical_history_screen.dart';
import 'screens/explore/explore_screen.dart';
import 'screens/profile/account_screen.dart';

// Local notification instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Request permission and setup notifications
  await _setupNotifications();

  // Optional: set status bar UI style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

Future<void> _setupNotifications() async {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission (Android 13+)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('Notification permission: ${settings.authorizationStatus}');

  // Fetch FCM token
  String? token = await messaging.getToken();
  print('FCM Token: $token');

  // Local notifications setup
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });
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
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRoutes.medicalHistory: (context) => const MedicalHistoryScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
        AppRoutes.otp: (context) => const OTPScreen(),
        AppRoutes.resetPassword: (context) => const ResetPasswordScreen(),
        AppRoutes.explore: (context) => const ExploreScreen(),
        AppRoutes.trackOrder: (context) => const TrackOrderScreen(),
        AppRoutes.account: (context) => const AccountScreen(),
        AppRoutes.orderStatus: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final isSuccess = args?['success'] ?? false;
          return OrderStatusScreen(isSuccess: isSuccess);
        },
      },
    );
  }
}
