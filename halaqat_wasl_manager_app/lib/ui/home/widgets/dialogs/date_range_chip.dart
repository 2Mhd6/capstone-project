import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

class DateRangeChip extends StatelessWidget {
  const DateRangeChip({super.key, required this.label, required this.tabIndex, required this.selectedIndex});

  final String label;
  final int tabIndex;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: context.getWidth(multiplied: 0.07),
      height: context.getHeight(multiplied: 0.035),
      decoration: BoxDecoration(
        color: tabIndex == selectedIndex ? AppColors.primaryAppColor : Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(label, style: tabIndex == selectedIndex ? AppTextStyle.sfProBold16White : AppTextStyle.sfPro60016),
    );
  }
}
