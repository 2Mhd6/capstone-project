import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/helpers/formatted_date.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_custom_button.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

class RequestChip extends StatelessWidget {
  const RequestChip({super.key, required this.request,required this.onPressed});

  final RequestModel request;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request.user!.fullName, style: AppTextStyle.sfPro60020),

                Gap.gapH8,

                Text('Pick up: ${request.pickUpReadableAddress}'),

                Text('Destination: ${request.hospital?.hospitalName}'),

                Text(FormattedDate.formattedDataForRequestChip(request.requestDate))
              ],
            ),

            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.pendingBackgroundColor,
              ),
              child: Text(
                tr('home_screen.pending'),
                style: AppTextStyle.sfPro60014.copyWith(
                  color: AppColors.pendingForegroundColor,
                ),
              ),
            ),
          ],
        ),

        Gap.gapH16,

        // -- When we connect the supabase uncomment this
        // if(request?.state == 'pending')
        AppCustomButton(
          label: tr('home_screen.assign_driver'),
          buttonColor: AppColors.primaryAppColor,
          width: context.getWidth(),
          height: context.getHeight(multiplied: 0.04),
          onPressed: onPressed,
        ),
        
        if (request.status == 'pending')
        Gap.gapH16,

        
      ],
    );
  }
}
