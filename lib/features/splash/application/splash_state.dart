import 'package:device_tracking_flutter_app/features/authentication/application/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_state.g.dart';

@riverpod
class SplashState extends _$SplashState {
  @override
  Future<SplashStatus> build() async {
    state = AsyncData(SplashStatus.waiting);
    ref.read(authStateProvider);
    await Future.delayed(Duration(seconds: 3));
    return SplashStatus.completed;
  }
}

enum SplashStatus { waiting, completed }
