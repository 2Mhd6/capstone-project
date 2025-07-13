import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/helpers/formatted_date.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/complaint_details_history_dialog.dart';

class ComplaintHistoryChip extends StatelessWidget {
  const ComplaintHistoryChip({super.key, required this.complaint});

  final ComplaintModel complaint;

  ({String text, Color backgroundColor, Color foregroundColor}) get status {
    switch (complaint.isActive) {
      case true:
        return (
          text: 'Active',
          backgroundColor: AppColors.pendingBackgroundColor,
          foregroundColor: AppColors.pendingForegroundColor,
        );
      case false:
        return (
          text: 'Inactive',
          backgroundColor: AppColors.completedBackgroundColor,
          foregroundColor: AppColors.completedForegroundColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context){
          return ComplaintDetailsHistoryDialog(
            complaint: complaint,
            formattedDate: FormattedDate.formattedDataForRequestDetails(
              complaint.request!.requestDate,
            ),
          );
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#REQ-${complaint.complaintId.toUpperCase().substring(0, 5)}',
                style: AppTextStyle.sfPro60020,
              ),
              Text(
                FormattedDate.formattedDataForRequestChip(
                  complaint.request!.requestDate,
                ),
              ),
              Text(
                complaint.complaint,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: status.backgroundColor,
                ),
                child: Text(
                  tr(status.text),
                  style: AppTextStyle.sfPro60014.copyWith(
                    color: status.foregroundColor,
                  ),
                ),
              ),
              Gap.gapH24,
            ],
          ),
        ],
      ),
    );
  }
}
