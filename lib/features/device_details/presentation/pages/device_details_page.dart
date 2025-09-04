import 'package:device_tracking_flutter_app/core/enums/role.dart';
import 'package:device_tracking_flutter_app/core/model/list_item_detail.dart';
import 'package:device_tracking_flutter_app/core/styles/app_color.dart';
import 'package:device_tracking_flutter_app/core/styles/app_text_theme.dart';
import 'package:device_tracking_flutter_app/core/widgets/async/async_value_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_app_bar_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_elevated_button.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_list_item_widget.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/auth_state.dart';
import 'package:device_tracking_flutter_app/features/device_details/presentation/widgets/device_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/device_details_state.dart';
import '../widgets/assign_device_popup.dart';

class DeviceDetailsPage extends ConsumerStatefulWidget {
  final int id;
  const DeviceDetailsPage({required this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends ConsumerState<DeviceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(deviceDetailsStateProvider(widget.id));
    final deviceInfo = provider.value;
    final deviceInfoItems = [
      ListItemDetail(
        title: 'Name',
        content: deviceInfo!.deviceName,
        onTap: () {},
      ),
      ListItemDetail(title: 'Model', content: deviceInfo.model),
      ListItemDetail(title: 'Platform', content: deviceInfo.platform),
    ];
    final isDeviceAvailable = deviceInfo.deviceHistory.isNotEmpty
        ? deviceInfo.deviceHistory.first.unassignedAt != null
        : true;
    final latestHistory =
        (deviceInfo.deviceHistory.length > 3 && isDeviceAvailable)
        ? deviceInfo.deviceHistory.take(2).toList()
        : deviceInfo.deviceHistory;

    final canAssignDevice =
        ref.read(authStateProvider.notifier).user?.role == Role.admin &&
            deviceInfo.deviceHistory.isEmpty
        ? true
        : deviceInfo.deviceHistory.first.unassignedAt != null;

    final canUnassignDevice =
        ref.read(authStateProvider.notifier).user?.role == Role.admin &&
        deviceInfo.deviceHistory.isNotEmpty &&
        !isDeviceAvailable;

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: provider.isLoading ? '' : deviceInfo.deviceName,
        centerTitle: true,
        titleTextStyle: AppTextTheme.getStyle(
          fontType: FontType.mediumTextStyle,
          fontSize: 16,
        ),
        showBackButton: true,
        actions: [
          if (provider.isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: () {
                ref
                    .read(deviceDetailsStateProvider(widget.id).notifier)
                    .refreshDevice();
              },
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: AsyncValueWidget(
        asyncValue: provider,
        data: (data) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Device Info',
                      style: AppTextTheme.getStyle(
                        fontType: FontType.boldTextStyle,
                        fontSize: 24,
                      ),
                    ),
                    Spacer(),
                    if (!isDeviceAvailable)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          "Request device",
                          style: AppTextTheme.getStyle(
                            fontType: FontType.mediumTextStyle,
                            fontSize: 12,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(deviceInfoItems.length, (index) {
                    final data = deviceInfoItems[index];
                    final isFirst = index == 0;
                    final isLast = index == deviceInfoItems.length - 1;

                    return CustomListItemWidget(
                      isFirst: isFirst,
                      isLast: isLast,
                      title: data.title,
                      trailingContent: data.content,
                      onTap: data.onTap,
                    );
                  }),
                ),
                if (canAssignDevice) SizedBox(height: 24),
                if (canAssignDevice)
                  CustomElevatedButton(
                    onTap: () => _onTapOfAssignDevice(context, deviceInfo.id),
                    buttonText: 'Assign Device',
                  ),
                if (canUnassignDevice) ...[
                  SizedBox(height: 24),
                  CustomElevatedButton(
                    onTap: () => _onTapOfUnassignDevice(context, deviceInfo.id),
                    buttonText: 'Unassign Device',
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                  ),
                ],
                DeviceHistoryWidget(deviceHistory: latestHistory),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapOfAssignDevice(BuildContext content, int id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AssignDevicePopup(id: id),
    );
  }

  void _onTapOfUnassignDevice(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.scaffoldBackgroundColor,
        title: Text(
          'Unassign Device',
          style: AppTextTheme.getStyle(
            fontType: FontType.boldTextStyle,
            fontSize: 20,
          ),
        ),
        content: Text(
          'Are you sure you want to unassign this device? This action will make the device available for reassignment.',
          style: AppTextTheme.getStyle(
            fontType: FontType.mediumTextStyle,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _unassignDevice(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: Text('Unassign', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _unassignDevice(int id) async {
    try {
      final success = await ref
          .read(deviceDetailsStateProvider(id).notifier)
          .unAssignDevice();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Device unassigned successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to unassign device'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
