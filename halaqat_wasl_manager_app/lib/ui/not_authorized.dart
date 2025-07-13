import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_custom_button.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/auth/auth_gate_screen.dart';

class NotAuthorized extends StatelessWidget {
  const NotAuthorized({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: context.getWidth(),
          child: Column(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'You\'re not authorized to get in with this app',
                style: AppTextStyle.sfPro60048,
              ),

              AppCustomButton(
                label: 'Sign up as Charity',
                buttonColor: AppColors.primaryAppColor,
                width: context.getWidth(multiplied: 0.3),
                height: context.getHeight(multiplied: 0.045),
                onPressed: () {
                  context.moveToWithReplacement(
                    context: context,
                    screen: AuthGateScreen(whereYouWantToGo: 'sign_up',),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}