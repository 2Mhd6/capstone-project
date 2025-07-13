import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

class StatisticChip extends StatelessWidget {
  const StatisticChip({super.key, required this.label, required this.statistic, required this.imagePath});

  final String label;
  final String statistic;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getWidth(multiplied: 0.2),
      height: context.getHeight(multiplied: 0.134),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            tr(label),
            style: AppTextStyle.sfProBold20SecondaryColor,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(statistic, style: AppTextStyle.sfPro60036),

              Image.asset(imagePath, width: 60, height: 60),
            ],
          ),
        ],
      ),
    );
  }
}
