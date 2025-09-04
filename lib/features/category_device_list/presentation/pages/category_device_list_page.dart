import 'package:device_tracking_flutter_app/core/assets_data/app_icons.dart';
import 'package:device_tracking_flutter_app/core/enums/role.dart';
import 'package:device_tracking_flutter_app/core/routes/app_routes.dart';
import 'package:device_tracking_flutter_app/core/styles/app_text_theme.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_app_bar_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_asset_icon_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_content_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_icon_button.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/auth_state.dart';
import 'package:device_tracking_flutter_app/features/category_device_list/application/category_device_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/styles/app_color.dart';
import '../../../../core/widgets/async/async_value_widget.dart';

class CategoryDeviceListPage extends ConsumerWidget {
  const CategoryDeviceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Mobiles Phones',
        showBackButton: true,
        centerTitle: true,
        titleTextStyle: AppTextTheme.getStyle(
          fontType: FontType.mediumTextStyle,
          fontSize: 16,
        ),
      ),
      floatingActionButton:
          ref.read(authStateProvider.notifier).user?.role == Role.admin
          ? SizedBox(
              height: 50,
              width: 200,
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () => context.push(AppRoutes.registerNewMobilePage),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(Icons.add, color: Colors.white, size: 22),
                    SizedBox(width: 6),
                    Text(
                      'Register new device',
                      style: AppTextTheme.getStyle(
                        fontType: FontType.mediumTextStyle,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: AsyncValueWidget(
        asyncValue: ref.watch(categoryDeviceListStateProvider),
        data: (data) {
          if (data == null) {
            return SizedBox.shrink();
          }
          return SizedBox.expand(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final deviceData = data[index];
                final isAvailable =
                    deviceData.deviceHistory.isEmpty ||
                    deviceData.deviceHistory.first.unassignedAt != null;
                return Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CustomAssetIconWidget(
                              iconPath: AppIcons.mobileIcon,
                            ),
                            SizedBox(width: 16),
                            CustomContentWidget(
                              title: deviceData.deviceName,
                              subTitle: deviceData.brand,
                            ),
                            Spacer(),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? Colors.green.shade100
                                    : AppColor.dividerColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SizedBox(
                                height: 30,
                                width: 80,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: isAvailable
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        isAvailable ? 'Available' : 'Assigned',
                                        style: AppTextTheme.getStyle(
                                          fontType: FontType.mediumTextStyle,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            CustomIconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: AppColor.dividerColor,
                              ),
                              onTap: () => context.push(
                                '${AppRoutes.deviceDetailsPage}/${deviceData.id}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemCount: data.length,
            ),
          );
        },
      ),
    );
  }
}
