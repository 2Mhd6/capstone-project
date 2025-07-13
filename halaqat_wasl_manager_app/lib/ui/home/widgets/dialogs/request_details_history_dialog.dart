import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

class RequestDetailsHistoryDialog extends StatelessWidget {
  final RequestModel request;
  final String formattedDate;

  const RequestDetailsHistoryDialog({
    super.key,
    required this.request,
    required this.formattedDate,
  });

    ({String text, Color backgroundColor, Color foregroundColor}) get status {
    switch (request.status) {
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
    return Dialog(
      child: Container(
        width: context.getWidth(multiplied: 0.5),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Request Details", style: AppTextStyle.sfProBold40),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#REQ-${request.requestId.substring(0, 5).toUpperCase()}",
                    style: AppTextStyle.sfProBold24,
                  ),
                  _buildStatusBox(
                    '${request.status[0].toUpperCase()}${request.status.substring(1)}',
                    status.foregroundColor,
                    status.backgroundColor
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Text(request.user!.fullName, style: AppTextStyle.sfProBold20),
              Text(request.user!.phoneNumber, style: AppTextStyle.sfPro60014SecondaryColor),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabeledText("Pick up", request.pickUpReadableAddress),
                  _buildLabeledText(
                    "Destination",
                    request.hospital?.hospitalName ?? '',
                  ),
                  _buildLabeledText("Time & Date", formattedDate),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                "Special Need",
                style: TextStyle(
                  color: AppColors.primaryButtonColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildReadonlyBox(request.note ?? 'There is no special needs'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBox(String status, Color foregroundColor,Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: AppTextStyle.sfProBold14.copyWith(
          color: foregroundColor,
        ),
      ),
    );
  }

  Widget _buildLabeledText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.sfProBold14),
        const SizedBox(height: 4),
        SizedBox(
          width: 150, // or adjust width as needed
          child: Text(
            value,
            style: AppTextStyle.sfPro60012TernaryColor,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildReadonlyBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: AppTextStyle.sfProMedium14.copyWith(color: Colors.black),
      ),
    );
  }
}
