import 'package:device_tracking_flutter_app/core/routes/app_routes.dart';
import 'package:device_tracking_flutter_app/features/authentication/pages/google_signin_page.dart';
import 'package:device_tracking_flutter_app/features/category_device_list/presentation/pages/category_device_list_page.dart';
import 'package:device_tracking_flutter_app/features/dashboard/presentation/pages/home_page.dart';
import 'package:device_tracking_flutter_app/features/device_details/presentation/pages/device_details_page.dart';
import 'package:device_tracking_flutter_app/features/device_registration/presentation/pages/device_registration_page.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/authentication/pages/registration_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

final appRouterConfig = GoRouter(
  initialLocation: AppRoutes.splashPage,
  routes: [
    GoRoute(
      path: AppRoutes.splashPage,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.homePage,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.userGoogleSigninPage,
      builder: (context, state) => const GoogleSigninPage(),
    ),
    GoRoute(
      path: AppRoutes.userRegistrationPage,
      builder: (context, state) {
        final googleSignInUserData = state.extra as GoogleSignInAccount;
        return UserRegistrationPage(googleSignInAccount: googleSignInUserData);
      },
    ),
    GoRoute(
      path: AppRoutes.categoryDevicesPage,
      builder: (context, state) => CategoryDeviceListPage(),
    ),
    GoRoute(
      path: "${AppRoutes.deviceDetailsPage}/:id",
      builder: (context, state) {
        final data = int.parse(state.pathParameters['id']!);
        return DeviceDetailsPage(id: data);
      },
    ),
    GoRoute(
      path: AppRoutes.registerNewMobilePage,
      builder: (context, state) => NewMobileRegistrationPage(),
    ),
  ],
);
