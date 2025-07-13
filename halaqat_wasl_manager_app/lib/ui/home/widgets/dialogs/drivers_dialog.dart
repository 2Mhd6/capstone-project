import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_custom_button.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/driver_info_chip.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/shared/search_textfield.dart';

class DriversDialog extends StatelessWidget {
  const DriversDialog({super.key});

  // final List<DriverModel> drivers;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: context.getWidth(multiplied: 0.5),
        height: context.getHeight(multiplied: 0.7),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: AppColors.appBackgroundColor
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr('driver_dialog_home_screen.drivers'), style: AppTextStyle.sfProBold40),
            
            Gap.gapH24,
            
            //SearchTextfield(label: 'driver_dialog_home_screen.search_driver', controller: TextEditingController()),
            
            Gap.gapH16,

            ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder:(context, index){
                return DriverInfoChip(driverName: 'Abdullah Saud Nasser', driverPhoneNumber: '+966599999999', driverTotalRides: '32', isActive: true);
              }
            )
          ],
        ),
      ),
    );
  }
}