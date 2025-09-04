import 'package:device_tracking_flutter_app/core/assets_data/app_images.dart';
import 'package:device_tracking_flutter_app/core/enums/role.dart';
import 'package:device_tracking_flutter_app/core/model/google_sign_in_user_entity.dart';
import 'package:device_tracking_flutter_app/core/routes/app_routes.dart';
import 'package:device_tracking_flutter_app/core/styles/app_text_theme.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_dropdown_widget.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_elevated_button.dart';
import 'package:device_tracking_flutter_app/core/widgets/custom_text_field_widget.dart';
import 'package:device_tracking_flutter_app/features/authentication/application/google_sign_in/google_sign_in_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/api/wrg_response.dart';
import '../../../core/model/user_registration_status.dart';
import '../../../core/utils/validator.dart';
import '../application/google_sign_in/google_signin_error_state.dart';

class UserRegistrationPage extends ConsumerStatefulWidget {
  final GoogleSignInAccount googleSignInAccount;
  const UserRegistrationPage({required this.googleSignInAccount, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserRegistrationPageState();
}

class _UserRegistrationPageState extends ConsumerState<UserRegistrationPage> {
  final _googleMailTextController = TextEditingController();
  final _mobileNumberTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _registrationFormKey = GlobalKey<FormState>();

  String _selectedCountryCode = '+91';

  final List<String> _countryCodes = ['+91', '+1', '+44', '+61', '+81'];

  Role? _selectedRole;

  @override
  void initState() {
    super.initState();
    _googleMailTextController.text = widget.googleSignInAccount.email;
    _nameTextController.text = widget.googleSignInAccount.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(googleSignInStateProvider, _onGoogleSignInStateChange);
    ref.listen<ApiError?>(googleSigninErrorStateProvider, _onGoogleSignInError);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            child: Form(
              key: _registrationFormKey,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hey ',
                        style: AppTextTheme.getStyle(
                          fontType: FontType.primaryTitleTextStyle,
                        ),
                      ),
                      Image.asset(AppImage.hiImage, height: 30, width: 30),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    widget.googleSignInAccount.displayName ?? 'User',
                    style: AppTextTheme.getStyle(
                      fontType: FontType.primaryTitleTextStyle,
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    textAlign: TextAlign.center,
                    'Welcome to our one step tracking solutions...',
                    style: AppTextTheme.getStyle(
                      fontType: FontType.primarySubTitleTextStyle,
                    ),
                  ),
                  CustomTextFieldWidget(
                    isReadOnly: true,
                    labelText: 'Work gmail',
                    controller: _googleMailTextController,
                    hintText: 'Your work google mail',
                    validator: (value) => multiValidator(value, [
                      emptyValidation,
                      (value) => validateEmail(value!),
                    ]),
                  ),
                  Row(
                    children: [
                      CustomDropDownWidget<String>(
                        labelText: 'Code',
                        validator: (value) =>
                            value == null ? 'Please select a code' : null,
                        items: _countryCodes.map((code) {
                          return DropdownMenuItem(
                            value: code,
                            child: Text(code),
                          );
                        }).toList(),
                        value: _selectedCountryCode,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCountryCode = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextFieldWidget(
                          labelText: 'Mobile number',
                          controller: _mobileNumberTextController,

                          hintText: 'Contact number',
                          keyboardType: TextInputType.phone,
                          validator: (value) => multiValidator(value, [
                            emptyValidation,
                            emptyValidation,
                          ]),
                        ),
                      ),
                    ],
                  ),
                  CustomTextFieldWidget(
                    labelText: 'Name',
                    controller: _nameTextController,
                    hintText: 'Enter your name',
                  ),
                  SizedBox(height: 20),
                  CustomDropDownWidget<Role>(
                    width: MediaQuery.sizeOf(context).width,
                    validator: (value) =>
                        value == null ? 'Please select a Role' : null,
                    labelText: 'Role',
                    items: Role.values.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.value),
                      );
                    }).toList(),
                    value: _selectedRole,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                  ),
                  Spacer(),
                  CustomElevatedButton(
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

  void _onGoogleSignInStateChange(
    AsyncValue<UserRegistrationStatus?>? previous,
    AsyncValue<UserRegistrationStatus?> next,
  ) {
    if (next.value != null && !next.isLoading) {
      if (next.value!.registeredUserData != null) {
        context.pushReplacement(AppRoutes.homePage);
      }
    }
  }

  void _onGoogleSignInError(ApiError? previous, ApiError? next) {
    if (next == null) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(next.message)));
  }

  void _onTapOfRegister() {
    final isValid = _registrationFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final newUser = GoogleSigninUserEntity(
      name: _nameTextController.text,
      email: _googleMailTextController.text,
      mobileNumber: _selectedCountryCode + _mobileNumberTextController.text,
      role: _selectedRole!.value,
      googleSigninId: widget.googleSignInAccount.id,
      googleSigninToken: widget.googleSignInAccount.authentication.idToken!,
    );

    ref.read(googleSignInStateProvider.notifier).registerNewGoogleUser(newUser);
  }
}
