import 'package:device_tracking_flutter_app/core/routes/app_routes.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/auth_state.dart';
import 'package:device_tracking_flutter_app/features/splash/application/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(splashStateProvider);
    });
  }

  void _onSplashStateChange(
    AsyncValue<SplashStatus>? previous,
    AsyncValue<SplashStatus?> next,
  ) {
    if (next.value != null && !next.isLoading) {
      if (next.value == SplashStatus.completed &&
          ref.read(authStateProvider).value != null) {
        context.pushReplacement(AppRoutes.homePage);
      } else {
        context.pushReplacement(AppRoutes.userGoogleSigninPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashStateProvider, _onSplashStateChange);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Track byte",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "WRG",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            LoadingAnimationWidget.halfTriangleDot(
              color: Colors.black,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }
}
