import 'package:device_tracking_flutter_app/core/routes/app_routes.dart';
import 'package:device_tracking_flutter_app/core/styles/app_color.dart';
import 'package:device_tracking_flutter_app/core/widgets/async/async_value_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_app_bar_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_list_item_widget.dart';
import 'package:device_tracking_flutter_app/features/device_list/application/device_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeviceListPage extends ConsumerStatefulWidget {
  const DeviceListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends ConsumerState<DeviceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Devices'),
      body: AsyncValueWidget(
        asyncValue: ref.watch(deviceListStateProvider),
        data: (data) {
          if (data == null) {
            return SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(data.length, (index) {
                final deviceData = data[index];
                final isFirst = index == 0;
                final isLast = index == data.length - 1;
                return CustomListItemWidget(
                  isFirst: isFirst,
                  isLast: isLast,
                  title: deviceData.name,
                  leadingIcon: deviceData.categoryImage.assetPath,
                  subTitle: '${deviceData.deviceCount} devices',
                  onTap: () => context.push(AppRoutes.categoryDevicesPage),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
