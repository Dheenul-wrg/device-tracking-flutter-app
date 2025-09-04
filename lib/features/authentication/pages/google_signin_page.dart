import 'package:device_tracking_flutter_app/core/api/wrg_response.dart';
import 'package:device_tracking_flutter_app/core/model/user_registration_status.dart';
import 'package:device_tracking_flutter_app/core/routes/app_routes.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/google_sign_in/google_sign_in_state.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/google_sign_in/google_signin_error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets_data/app_icons.dart';
import '../../../core/widgets/custom_elevated_button.dart';

class GoogleSigninPage extends ConsumerStatefulWidget {
  const GoogleSigninPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoogleSigninPageState();
}

class _GoogleSigninPageState extends ConsumerState<GoogleSigninPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(googleSignInStateProvider, _onGoogleSignInStateChange);
    ref.listen<ApiError?>(googleSigninErrorStateProvider, _onGoogleSignInError);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.raleway(
                      fontWeight: FontWeight.w500,
                    ).fontFamily,
                  ),
                  children: [
                    TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(fontSize: 18),
                    ),
                    TextSpan(
                      text: 'Track Byte',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Continue signing with your work gmail account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 80),
              Consumer(
                builder: (context, ref, child) {
                  return CustomElevatedButton(
                    iconPath: AppIcons.googleIcon,
                    buttonText: "Sign in with Google",
                    onTap: ref
                        .read(googleSignInStateProvider.notifier)
                        .signInWithGoogle,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGoogleSignInStateChange(
    AsyncValue<UserRegistrationStatus?>? previous,
    AsyncValue<UserRegistrationStatus?> next,
  ) {
    if (next.value != null && !next.isLoading) {
      if (next.value!.registeredUserData != null) {
        context.pushReplacement(AppRoutes.homePage);
      }

      if (next.value!.userGoogleSignData != null) {
        context.push(
          AppRoutes.userRegistrationPage,
          extra: next.value!.userGoogleSignData,
        );
      }
    }
  }

  void _onGoogleSignInError(ApiError? previous, ApiError? next) {
    if (next == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(next.message)));
  }
}
