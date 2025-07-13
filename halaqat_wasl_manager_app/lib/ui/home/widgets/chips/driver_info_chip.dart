import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_custom_button.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

// Inside the drivers view all section
class DriverInfoChip extends StatelessWidget {
  const DriverInfoChip({
    super.key,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.driverTotalRides,
    required this.isActive,
  });

  final String driverName;
  final String driverPhoneNumber;
  final String driverTotalRides;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              tr('driver_dialog_home_screen.name'),
              style: AppTextStyle.sfPro60014SecondaryColor,
            ),
            Text(driverName, style: AppTextStyle.sfPro60016),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              tr('driver_dialog_home_screen.phone_number'),
              style: AppTextStyle.sfPro60014SecondaryColor,
            ),
            Text(driverPhoneNumber, style: AppTextStyle.sfPro60016),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Text(
              tr('driver_dialog_home_screen.total_services'),
              style: AppTextStyle.sfPro60014SecondaryColor,
            ),
            Text(driverTotalRides, style: AppTextStyle.sfPro60016),
          ],
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Gap.gapH16,
            AppCustomButton(
              label: isActive
                  ? tr('driver_dialog_home_screen.inactive')
                  : tr('driver_dialog_home_screen.active'),
              buttonColor: isActive
                  ? AppColors.inactiveButtonColor
                  : AppColors.primaryAppColor,
              width: 110,
              height: 20,
              isDriverInfoChip: true,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
