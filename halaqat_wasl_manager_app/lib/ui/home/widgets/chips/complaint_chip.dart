import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_custom_button.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

class ComplaintChip extends StatelessWidget {
  const ComplaintChip({super.key, required this.complaint, required this.onPressed});

  final ComplaintModel complaint;
  final void Function()? onPressed;
  
  ({String text, Color backgroundColor, Color foregroundColor}) get status{
    switch (complaint.isActive) {
      case true:
        return (text: 'home_screen.response',backgroundColor: AppColors.completedBackgroundColor, foregroundColor: AppColors.completedForegroundColor);
        
      default:
       return (text: 'home_screen.completed',backgroundColor: AppColors.pendingForegroundColor, foregroundColor: AppColors.pendingBackgroundColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(complaint.user!.fullName, style: AppTextStyle.sfPro60020),
                
              ],
            ),


            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.pendingBackgroundColor,
              ),
              child: Text(
                complaint.isActive ? 'Active' : 'Inactive',
                style: AppTextStyle.sfPro60014.copyWith(
                  color: AppColors.pendingForegroundColor,
                ),
              ),
            ),
          ],
        ),

        Gap.gapH16,
        
        Text(complaint.complaint, style: AppTextStyle.sfProBold14SecondaryColor),

        Gap.gapH16,

        if (complaint.isActive)
          AppCustomButton(
            label: tr('home_screen.response_complaint'),
            buttonColor: AppColors.responseButtonColor,
            width: context.getWidth(),
            height: context.getHeight(multiplied: 0.04),
            onPressed: onPressed,
          ),


        Divider(color: AppColors.secondaryColor, thickness: 2, height: 20),
      ],
    );
  }
}
