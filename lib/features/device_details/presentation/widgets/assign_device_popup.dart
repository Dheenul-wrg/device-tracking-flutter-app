//
import 'dart:async';

import 'package:device_tracking_flutter_app/features/device_details/application/search_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/model/user.dart';
import '../../../../core/styles/app_color.dart';
import '../../../../core/styles/app_text_theme.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_icon_button.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../../authentication/application/auth_state.dart';
import '../../application/device_details_state.dart';

class AssignDevicePopup extends ConsumerStatefulWidget {
  final int id;
  const AssignDevicePopup({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssignDevicePopupState();
}

class _AssignDevicePopupState extends ConsumerState<AssignDevicePopup> {
  final TextEditingController _emailController = TextEditingController();
  Timer? _debounce;
  String? _errorText;
  bool _isAssigning = false;
  User? _selectedUser;

  @override
  void dispose() {
    _debounce?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.isNotEmpty) {
        _searchUser(query);
      } else {
        ref.read(searchUserStateProvider.notifier).clearSearch();
        setState(() {
          _selectedUser = null;
        });
      }
    });
  }

  Future<void> _searchUser(String keyword) async {
    await ref.read(searchUserStateProvider.notifier).searchUser(keyword);
  }

  void _selectUser(User user) {
    setState(() {
      _selectedUser = user;
      _emailController.text = user.userEmail;
    });
    // Clear the search results after selection
    ref.read(searchUserStateProvider.notifier).clearSearch();
  }

  void _assignSelectedDevice() async {
    if (_selectedUser == null) {
      setState(() {
        _errorText = 'Please select a user from the list';
      });
      return;
    }

    setState(() {
      _isAssigning = true;
    });

    try {
      await ref
          .read(deviceDetailsStateProvider(widget.id).notifier)
          .assignDevice(
            assignToUserId: _selectedUser!.userId,
            assignedByUserId: ref.read(authStateProvider.notifier).user!.userId,
          );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Device assigned successfully to ${_selectedUser!.userName}',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorText = 'Failed to assign device. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAssigning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = ref.watch(searchUserStateProvider);
    ref.listen(searchUserStateProvider, _onSearchStateChange);

    return AlertDialog(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Assign device',
            style: AppTextTheme.getStyle(
              fontType: FontType.boldTextStyle,
              fontSize: 20,
            ),
          ),
          CustomIconButton(
            icon: Icon(Icons.close_rounded),
            onTap: () {
              ref.read(searchUserStateProvider.notifier).clearSearch();
              context.pop();
            },
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFieldWidget(
              labelText: 'User email',
              controller: _emailController,
              hintText: 'Enter the registered user email',
              onChanged: _onSearchChanged,
              errorText: _errorText,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Search Results Section
            if (searchProvider.isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Searching...'),
                  ],
                ),
              )
            else if (searchProvider.hasError)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        searchProvider.error.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              )
            else if (searchProvider.value != null &&
                searchProvider.value!.users.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Show only first 3 users
                    ...searchProvider.value!.users
                        .take(3)
                        .map(
                          (user) => ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black,
                              child: Text(
                                user.userName.isNotEmpty
                                    ? user.userName[0].toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            title: Text(
                              user.userName,
                              style: AppTextTheme.getStyle(
                                fontType: FontType.mediumTextStyle,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              user.userEmail,
                              style: AppTextTheme.getStyle(
                                fontType: FontType.regularTextStyle,
                                fontSize: 11,
                                textColor: Colors.grey.shade600,
                              ),
                            ),
                            onTap: () => _selectUser(user),
                          ),
                        ),
                    // Show "more results" indicator if there are more than 3 users
                    if (searchProvider.value!.users.length > 3)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          '... and ${searchProvider.value!.users.length - 3} more results',
                          style: AppTextTheme.getStyle(
                            fontType: FontType.regularTextStyle,
                            fontSize: 11,
                            textColor: Colors.grey.shade500,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else if (searchProvider.value != null &&
                searchProvider.value!.users.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'No users found',
                      style: AppTextTheme.getStyle(
                        fontType: FontType.mediumTextStyle,
                        fontSize: 14,
                        textColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

            // Selected User Display
            if (_selectedUser != null) ...[
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected User',
                            style: AppTextTheme.getStyle(
                              fontType: FontType.boldTextStyle,
                              fontSize: 14,
                              textColor: Colors.green,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Name: ${_selectedUser!.userName}',
                            style: AppTextTheme.getStyle(
                              fontType: FontType.mediumTextStyle,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Email: ${_selectedUser!.userEmail}',
                            style: AppTextTheme.getStyle(
                              fontType: FontType.mediumTextStyle,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 16),
            CustomElevatedButton(
              buttonColor: _selectedUser != null ? Colors.black : Colors.grey,
              onTap: _selectedUser != null && !_isAssigning
                  ? _assignSelectedDevice
                  : null,
              buttonText: _isAssigning ? 'Assigning...' : 'Assign',
              textColor: _selectedUser != null ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchStateChange(
    AsyncValue<SearchUserData?>? previous,
    AsyncValue<SearchUserData?> next,
  ) async {
    if (!next.isLoading && next.value != null) {
      if (!next.value!.isValidUser) {
        setState(() {
          _errorText = 'No users found. Please check the search query.';
        });
      } else {
        setState(() {
          _errorText = null;
        });
      }
    }
  }
}
