import 'package:device_tracking_flutter_app/core/extensions/extensions.dart';
import 'package:device_tracking_flutter_app/core/model/device_history.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_color.dart';
import '../../../../core/styles/app_text_theme.dart';

class DeviceHistoryWidget extends StatelessWidget {
  final List<DeviceHistory> deviceHistory;
  const DeviceHistoryWidget({super.key, required this.deviceHistory});

  @override
  Widget build(BuildContext context) {
    final latestHistory = (deviceHistory.length > 3)
        ? deviceHistory.take(2).toList()
        : deviceHistory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'Assignee History',
          style: AppTextTheme.getStyle(
            fontType: FontType.boldTextStyle,
            fontSize: 24,
          ),
        ),
        if (deviceHistory.isNotEmpty) SizedBox(height: 16),
        if (deviceHistory.isNotEmpty)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(latestHistory.length, (index) {
              final data = latestHistory[index];
              final assigneeDetails = data.userDetails;
              final isFirst = index == 0;
              final isLast = index == latestHistory.length - 1;

              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: isFirst ? Radius.circular(8) : Radius.zero,
                    topRight: isFirst ? Radius.circular(8) : Radius.zero,
                    bottomLeft: isLast ? Radius.circular(8) : Radius.zero,
                    bottomRight: isLast ? Radius.circular(8) : Radius.zero,
                  ),
                  border: Border(
                    bottom: isLast
                        ? BorderSide.none
                        : BorderSide(color: AppColor.dividerColor),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                          left: 16,
                          right: 4,
                        ),
                        child: VerticalDivider(
                          width: 1,
                          color: AppColor.dividerColor,
                          thickness: 6,
                          radius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assigneeDetails.userName,
                              style: AppTextTheme.getStyle(
                                fontType: FontType.mediumTextStyle,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'From: ${data.assignedAt.toFormattedString()}',
                              style: AppTextTheme.getStyle(
                                fontType: FontType.regularTextStyle,
                                textColor: AppColor.trailingTextColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'To: ${data.unassignedAt?.toFormattedString() ?? '--'}',
                              style: AppTextTheme.getStyle(
                                fontType: FontType.regularTextStyle,
                                textColor: AppColor.trailingTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        SizedBox(height: 24),
        if (deviceHistory.isEmpty)
          Align(
            alignment: Alignment.center,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: SizedBox(
                height: 50,
                width: MediaQuery.sizeOf(context).width,
                child: Center(
                  child: Text(
                    "No assigning history for the device ",
                    style: AppTextTheme.getStyle(
                      fontType: FontType.mediumTextStyle,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (latestHistory.length > 2)
          Align(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: Text(
                "Show full history",
                style: AppTextTheme.getStyle(
                  fontType: FontType.mediumTextStyle,
                  fontSize: 12,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
