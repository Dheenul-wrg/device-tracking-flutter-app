import 'package:device_tracking_flutter_app/core/model/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/device_data_source_impl.dart';

part 'search_user_state.g.dart';

@riverpod
class SearchUserState extends _$SearchUserState {
  @override
  Future<SearchUserData?> build() async {
    return null;
  }

  Future<void> searchUser(String userMail) async {
    try {
      state = AsyncLoading();

      final result = await ref
          .read(deviceDataSourceProvider)
          .searchUser(userMail);

      if (!result.isSuccess) {
        state = AsyncError(result.error!, StackTrace.current);
        return;
      }

      // Return all users that match the search query
      final List<User> matchingUsers = result.data ?? [];

      state = AsyncData(
        SearchUserData(
          users: matchingUsers,
          isValidUser: matchingUsers.isNotEmpty,
        ),
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void clearSearch() {
    state = AsyncData(null);
  }
}

class SearchUserData {
  final List<User> users;
  final bool isValidUser;

  SearchUserData({required this.users, required this.isValidUser});
}
