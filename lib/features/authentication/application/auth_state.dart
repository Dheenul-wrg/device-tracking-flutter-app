import 'dart:convert';

import 'package:device_tracking_flutter_app/core/preference/preference.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/google_sign_in/google_sign_in_state.dart';
import 'package:device_tracking_flutter_app/features/authentication/data/auth_data_source_impl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/model/user.dart';

part 'auth_state.g.dart';

abstract class AuthStateBase {
  bool get isLoggedIn;

  /// User sign up via network
  Future<void> signup();

  Future<void> logout();

  /// User sign in from local preference
  Future<User?> silentLogin();

  /// Saving the user details to the local storage
  Future<void> saveUserToPreference(User user);

  /// Clearning the user details from the local preference
  Future<void> clearUserFromPreference(String key);

  /// To sign in or sign up the user with a google account
  Future<void> signInWithGoogle();

  /// Refresh user data from server (useful after device assignments)
  Future<void> refreshUserData();
}

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState implements AuthStateBase {
  User? get user => state.value;

  set user(User? value) => state = AsyncData(value);

  @override
  bool get isLoggedIn => state.value != null;

  @override
  FutureOr<User?> build() {
    return silentLogin();
  }

  @override
  Future<void> clearUserFromPreference(String key) async {
    await ref.read(preferenceProvider).clear(key);
  }

  @override
  Future<void> logout() async {
    try {
      print('🚪 Starting logout process...');

      // Clear all user data from preferences
      await ref.read(preferenceProvider).clearAll();
      print('🗑️ All preferences cleared');

      // Clear Google sign-in state
      try {
        final googleSignIn = GoogleSignIn.instance;
        await googleSignIn.signOut();
        print('🔓 Google sign-in cleared');
      } catch (e) {
        print('⚠️ Error clearing Google sign-in: $e');
      }

      // Reset the auth state
      state = AsyncData(null);

      // Clear any other related data if needed
      ref.invalidateSelf();

      print('✅ Logout completed successfully');
    } catch (e) {
      // Handle any errors during logout
      print('❌ Error during logout: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveUserToPreference(User user) async {
    await ref
        .read(preferenceProvider)
        .setValue<String>(PreferenceKeys.userKey, jsonEncode(user));
  }

  @override
  Future<void> signInWithGoogle() async {
    ref.read(googleSignInStateProvider.notifier).signInWithGoogle();
  }

  @override
  Future<void> refreshUserData() async {
    try {
      print('🔄 Refreshing user data from server...');

      if (state.value == null) {
        print('⚠️ No user logged in, cannot refresh');
        return;
      }

      // Get the current user's ID
      final currentUserId = state.value!.userId;
      print('👤 Refreshing data for user ID: $currentUserId');
      print(
        '📱 Current assigned devices count: ${state.value!.assignedDevices.length}',
      );

      // Fetch latest user data from server
      final result = await ref
          .read(authDataSourceProvider)
          .getUser(currentUserId.toString());

      if (result.isSuccess && result.data != null) {
        print('✅ Server data fetched successfully');
        print(
          '📱 New assigned devices count: ${result.data!.assignedDevices.length}',
        );

        // Update the state with fresh data
        state = AsyncData(result.data);

        // Update the user data in shared preferences
        await saveUserToPreference(result.data!);
        print('💾 User data updated in shared preferences');

        print('🔄 User data refresh completed successfully');
      } else {
        print('⚠️ Failed to refresh user data from server: ${result.error}');
        // If server refresh fails, just update preferences with current state
        await saveUserToPreference(state.value!);
        print('💾 Updated preferences with current state (fallback)');
      }
    } catch (e) {
      print('❌ Error refreshing user data: $e');
      // Don't rethrow - we don't want to break the app if refresh fails
      // Just update preferences with current state as fallback
      try {
        await saveUserToPreference(state.value!);
        print('💾 Fallback: Updated preferences with current state');
      } catch (prefError) {
        print('❌ Failed to update preferences: $prefError');
      }
    }
  }

  @override
  Future<void> signup() {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<User?> silentLogin() async {
    final response = await ref
        .read(preferenceProvider)
        .getValue<String>(PreferenceKeys.userKey);
    if (response != null) {
      return User.fromJson(jsonDecode(response));
    }
    return null;
  }
}
