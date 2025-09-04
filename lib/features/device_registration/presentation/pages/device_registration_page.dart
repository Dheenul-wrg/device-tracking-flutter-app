import 'package:device_tracking_flutter_app/core/routes/app_routes.dart';
import 'package:device_tracking_flutter_app/core/styles/app_color.dart';
import 'package:device_tracking_flutter_app/core/styles/app_text_theme.dart';
import 'package:device_tracking_flutter_app/core/utils/validator.dart';
import 'package:device_tracking_flutter_app/core/widgets/async/async_button.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_app_bar_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_text_field_widget.dart';
import 'package:device_tracking_flutter_app/features/device_registration/application/mobile_registration/mobile_basic_info_state.dart';
import 'package:device_tracking_flutter_app/features/device_registration/application/mobile_registration/mobile_registration_state.dart';
import 'package:device_tracking_flutter_app/features/device_registration/application/mobile_registration_error/mobile_registration_error_state.dart';
import 'package:device_tracking_flutter_app/features/device_registration/domain/model/device_basic_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/wrg_response.dart';
import '../../../../core/model/mobile_info.dart';
import '../../../../core/model/new_device_entity.dart';

class NewMobileRegistrationPage extends ConsumerStatefulWidget {
  const NewMobileRegistrationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewMobileRegistrationPageState();
}

class _NewMobileRegistrationPageState
    extends ConsumerState<NewMobileRegistrationPage> {
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _imeiController = TextEditingController();
  final _macAddressController = TextEditingController();
  final _platformController = TextEditingController();
  final _brandController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(mobileBasicInfoStateProvider, _onMobileInfoStateChange);
    ref.listen<ApiError?>(
      mobileRegistrationErrorStateProvider,
      _onRegistrationErrorStateChange,
    );
    ref.listen(mobileRegistrationStateProvider, _registrationStateChange);
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Add new mobile',
        showBackButton: true,
        centerTitle: true,
        titleTextStyle: AppTextTheme.getStyle(
          fontType: FontType.mediumTextStyle,
          fontSize: 16,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Device Details',
                        style: AppTextTheme.getStyle(
                          fontType: FontType.boldTextStyle,
                          fontSize: 24,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: ref
                            .read(mobileBasicInfoStateProvider.notifier)
                            .getBasicDeviceInfo,
                        child: Text(
                          "Get basic info",
                          style: AppTextTheme.getStyle(
                            fontType: FontType.mediumTextStyle,
                            fontSize: 12,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomTextFieldWidget(
                    labelText: 'Device name',
                    controller: _nameController,
                    hintText: 'Enter device name',
                    validator: (value) {
                      return emptyValidation(value);
                    },
                  ),
                  CustomTextFieldWidget(
                    labelText: 'Model',
                    controller: _modelController,
                    hintText: 'Enter device model',
                    validator: (value) {
                      return emptyValidation(value);
                    },
                  ),
                  CustomTextFieldWidget(
                    labelText: 'Brand',
                    controller: _brandController,
                    hintText: 'Enter device brnad',
                    validator: (value) {
                      return emptyValidation(value);
                    },
                  ),
                  CustomTextFieldWidget(
                    labelText: 'Platform',
                    controller: _platformController,
                    hintText: 'Enter device platform',
                    validator: (value) {
                      return emptyValidation(value);
                    },
                  ),
                  CustomTextFieldWidget(
                    labelText: 'Serial no',
                    controller: _serialNumberController,
                    hintText: 'Enter device serial number',
                    validator: (value) {
                      return emptyValidation(value);
                    },
                  ),
                  CustomTextFieldWidget(
                    labelText: 'IMEI no',
                    controller: _imeiController,
                    hintText: 'Enter device IMEI number',
                    validator: (value) {
                      return emptyValidation(value);
                    },
                  ),
                  CustomTextFieldWidget(
                    labelText: 'Mac address',
                    controller: _macAddressController,
                    hintText: 'Enter device Mac address',
                    validator: (value) {
                      return emptyValidation(value);
                    },
                  ),
                  SizedBox(height: 40),
                  AsyncButton(
                    horizontalPadding: 0,
                    asyncValue: ref.watch(mobileRegistrationStateProvider),
                    onTap: _onTapOfRegister,
                    buttonText: 'Register',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapOfRegister() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final newDevice = NewMobileEntity(
      serialNumber: _serialNumberController.text,
      platform: _platformController.text,
      brand: _brandController.text,
      model: _modelController.text,
      macAddress: _macAddressController.text,
      imeiNumber: _imeiController.text,
      deviceName: _nameController.text,
    );

    await ref
        .read(mobileRegistrationStateProvider.notifier)
        .registerNewMobile(newDevice);
  }

  void _onMobileInfoStateChange(
    AsyncValue<DeviceBasicInfo?>? previou,
    AsyncValue<DeviceBasicInfo?> next,
  ) {
    if (next.value != null && !next.isLoading) {
      final details = next.value!;
      _modelController.text = details.model;
      _nameController.text = details.name;
      _platformController.text = details.platform;
      _brandController.text = details.brand;

      ref.read(mobileBasicInfoStateProvider.notifier).resetState();
    }
  }

  void _onRegistrationErrorStateChange(ApiError? previous, ApiError? next) {
    if (next == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(next.message)));
  }

  void _registrationStateChange(
    AsyncValue<MobileInfo?>? previous,
    AsyncValue<MobileInfo?> next,
  ) async {
    if (next.value != null && !next.isLoading) {
      context.pushReplacement(
        "${AppRoutes.deviceDetailsPage}/${next.value!.id}",
      );
    }
  }
}
