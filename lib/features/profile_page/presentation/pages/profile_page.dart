import 'package:device_tracking_flutter_app/core/routes/app_routes.dart';
import 'package:device_tracking_flutter_app/core/styles/app_color.dart';
import 'package:device_tracking_flutter_app/core/styles/app_text_theme.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_app_bar_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_asset_icon_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_content_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_list_item_widget.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/model/list_item_detail.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Refresh user data when app becomes visible
      _refreshUserData();
    }
  }

  Future<void> _refreshUserData() async {
    try {
      await ref.read(authStateProvider.notifier).refreshUserData();
      print('🔄 Profile auto-refreshed on app resume');
    } catch (e) {
      print('⚠️ Auto-refresh failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value!;

    // Log when profile page rebuilds with new data
    print(
      '🔄 Profile page rebuilding - User: ${user.userName}, Devices: ${user.assignedDevices.length}',
    );

    final profileData = [
      ListItemDetail(title: 'Name', content: user.userName, onTap: () {}),
      ListItemDetail(title: 'Email', content: user.userEmail),
      ListItemDetail(
        title: 'Phone Number',
        content: user.userMobileNumber,
        onTap: () {},
      ),
      ListItemDetail(title: 'Role', content: user.role!.value, onTap: () {}),
    ];
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await ref.read(authStateProvider.notifier).refreshUserData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile refreshed successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to refresh profile'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      backgroundColor: AppColor.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(profileData.length, (index) {
                final data = profileData[index];
                final isFirst = index == 0;
                final isLast = index == profileData.length - 1;
                return CustomListItemWidget(
                  isFirst: isFirst,
                  isLast: isLast,
                  title: data.title,
                  trailingContent: data.content,
                  onTap: data.onTap,
                );
              }),
            ),
            if (user.assignedDevices.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current Devices',
                    style: AppTextTheme.getStyle(
                      fontType: FontType.boldTextStyle,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            if (user.assignedDevices.isNotEmpty)
              Expanded(
                child: SizedBox.expand(
                  child: Scrollbar(
                    interactive: true,
                    thumbVisibility: user.assignedDevices.length > 3,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        right: user.assignedDevices.length > 3 ? 8 : 0,
                      ),
                      child: Column(
                        children: List.generate(user.assignedDevices.length, (
                          index,
                        ) {
                          final deviceData = user.assignedDevices[index];
                          final isLast =
                              index == user.assignedDevices.length - 1;
                          return Column(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      CustomAssetIconWidget(
                                        iconPath: deviceData
                                            .device
                                            .categoryDetails
                                            .categoryImage
                                            .assetPath,
                                      ),
                                      SizedBox(width: 16),
                                      CustomContentWidget(
                                        title: deviceData
                                            .device
                                            .mobileInfo
                                            .deviceName,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isLast) SizedBox(height: 12),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            if (user.assignedDevices.isNotEmpty) SizedBox(height: 16),
            // Add spacing when there's no device history
            if (user.assignedDevices.isEmpty) ...[
              SizedBox(height: 40),
              // Add a visual separator when no devices
              Container(
                width: double.infinity,
                height: 1,
                color: AppColor.dividerColor.withOpacity(0.3),
              ),
              SizedBox(height: 20),
              // Show message when no devices
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.devices_other,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Assigned Devices',
                      style: AppTextTheme.getStyle(
                        fontType: FontType.boldTextStyle,
                        fontSize: 18,
                        textColor: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You don\'t have any devices assigned to you at the moment.',
                      style: AppTextTheme.getStyle(
                        fontType: FontType.mediumTextStyle,
                        fontSize: 14,
                        textColor: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                  bottom: Radius.circular(30),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // First Action
                    Material(
                      color: Colors.transparent,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _onSignOut(context, ref),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 20, 20),
                          child: Column(
                            children: [
                              Icon(Icons.power_settings_new),
                              SizedBox(height: 4),
                              Text(
                                "Sign Out",
                                style: AppTextTheme.getStyle(
                                  fontType: FontType.mediumTextStyle,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 1,
                      color: AppColor.dividerColor,
                      thickness: 1,
                    ),
                    Material(
                      color: Colors.transparent,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => _onSignOut(context, ref),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
                          child: Column(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(height: 4),
                              Text(
                                "Edit Profile",
                                style: AppTextTheme.getStyle(
                                  fontType: FontType.mediumTextStyle,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignOut(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.scaffoldBackgroundColor,
        title: Text(
          'Sign Out',
          style: AppTextTheme.getStyle(
            fontType: FontType.boldTextStyle,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: AppTextTheme.getStyle(
            fontType: FontType.mediumTextStyle,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      try {
        // Sign out the user
        await ref.read(authStateProvider.notifier).logout();

        // Navigate to splash page (which will redirect to login)
        if (context.mounted) {
          context.go(AppRoutes.splashPage);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing out: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
