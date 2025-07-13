import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/helpers/validator.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_custom_button.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_snack_bart.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/auth/bloc/auth_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/auth/auth_gate_screen.dart';
import 'package:halaqat_wasl_manager_app/ui/auth/widgets/auth_text_field_with_label.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    

    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ErrorState) {
            appSnackBar(
              context: context,
              message: state.errorMessage,
              isSuccess: false,
            );
          } else if (state is SuccessState) {
            context.moveToWithReplacement(
              context: context,
              screen: AuthGateScreen(),
            );
          }
        },
        child: Builder(
          builder: (context) {

            final authBloc = context.read<AuthBloc>();
            
            return Scaffold(
              body: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: context.getWidth(multiplied: 0.16),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Gap.gapH40,
            
                        Image.asset(
                          'assets/auth/logo-halaqat-wasl.png',
                          width: context.getWidth(),
                          height: context.getHeight(multiplied: 0.14),
                        ),
            
                        Gap.gapH40,
            
                        Container(
                          width: context.getWidth(multiplied: 1),
                          height: context.getHeight(multiplied: 0.78),
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('sign_up_screen.sign_up_title'),
                                style: AppTextStyle.sfProBold40,
                              ),
            
                              Gap.gapH8,
            
                              Text(
                                tr('sign_up_screen.onboarding_text'),
                                style: AppTextStyle.sfPro60020SecondaryColor,
                              ),
            
                              Gap.gapH32,
            
                              Form(
                                key: authBloc.signUpKey,
                                child: Column(
                                  children: [
                                    AuthTextFieldWithLabel(
                                      label: tr('sign_up_screen.charity_name'),
                                      controller: authBloc.charityNameController,
                                      onValidate: null,
                                    ),
            
                                    AuthTextFieldWithLabel(
                                      label: tr('sign_up_screen.charity_license'),
                                      controller: authBloc.charityNumberController,
                                      isCharityNumber: true,
                                      onValidate: licenseNumberValidator,
                                    ),
            
                                    AuthTextFieldWithLabel(
                                      label: tr('sign_up_screen.email'),
                                      controller: authBloc.emailController,
                                      onValidate: emailValidator,
                                    ),
            
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        return AuthTextFieldWithLabel(
                                          label: tr('sign_up_screen.password'),
                                          controller: authBloc.passwordController,
                                          isPassword: true,
                                          isShowPassword: authBloc.isShowPassword,
                                          onValidate: passwordValidator,
                                          onPressedToShowPasswordViability: () =>
                                              authBloc.add(
                                                TogglePasswordViabilityEvent(),
                                              ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
            
                              Spacer(),
            
                              AppCustomButton(
                                label: tr('sign_up_screen.sign_up'),
                                buttonColor: AppColors.primaryAppColor,
                                width: context.getWidth(),
                                height: context.getHeight(multiplied: 0.05),
                                onPressed: () async {
                                  // Check the validation here
                                  if (authBloc.signUpKey.currentState!.validate()) {
                                    authBloc.add(SignUpEvent());
                                    await Future.delayed(Duration(seconds: 1));
                                  }
                                  // After Checking go to Auth Gate screen and then to Home screen
                                },
                              ),

                              Gap.gapH24,

                              AppCustomButton(
                                label: tr('sign_up_screen.login'),
                                buttonColor: AppColors.secondaryColor,
                                width: context.getWidth(),
                                height: context.getHeight(multiplied: 0.05),
                                onPressed: () {
                                  context.moveToWithReplacement(context: context, screen: AuthGateScreen(whereYouWantToGo: 'log_in',));
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
