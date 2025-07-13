import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/helpers/formatted_date.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/request_details_history_dialog.dart';

class HistoryChip extends StatelessWidget {
  const HistoryChip({
    super.key,
    this.request,
    this.complaint,
    required this.state,
  });

  final RequestModel? request;
  final ComplaintModel? complaint;
  final String state;

  ({String text, Color backgroundColor, Color foregroundColor}) get status {
    switch (state) {
      case 'pending':
        return (
          text: 'home_screen.pending',
          backgroundColor: AppColors.pendingBackgroundColor,
          foregroundColor: AppColors.pendingForegroundColor,
        );

      case 'completed':
        return (
          text: 'home_screen.completed',
          backgroundColor: AppColors.completedBackgroundColor,
          foregroundColor: AppColors.completedForegroundColor,
        );
      default:
        return (
          text: 'home_screen.accepted',
          backgroundColor: AppColors.acceptedBackgroundColor,
          foregroundColor: AppColors.acceptedForegroundColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() => context.moveTo(context: context, screen: RequestDetailsHistoryDialog(request: request!, formattedDate: FormattedDate.formattedDataForRequestDetails(request!.requestDate))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('#REQ-${request?.requestId.toUpperCase().substring(0,5)}', style: AppTextStyle.sfPro60020),
              Text(FormattedDate.formattedDataForRequestChip(request!.requestDate)),
              Text('Pick up - ${request!.pickUpReadableAddress}\nDestination - ${request!.hospital!.hospitalName}'),
            ],
          ),
      
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
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

    // ListTile(
    //   title: Text('#Req-YF34', style: AppTextStyle.sfPro60020),
    //   subtitle: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text('27/7/2025 - 10 AM'),
    //       Text('Pick up -> Destination')
    //     ],
    //   ),
    //   trailing: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       Container(
    //         padding: EdgeInsets.all(8),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(10),
    //           color: status.backgroundColor,
    //         ),
    //         child: Text(
    //           tr(status.text),
    //           style: AppTextStyle.sfPro60014.copyWith(
    //             color: status.foregroundColor,
    //           ),
    //         ),
    //       ),

    //       Gap.gapH24
    //     ],
    //   ),
    // );
  }
}
