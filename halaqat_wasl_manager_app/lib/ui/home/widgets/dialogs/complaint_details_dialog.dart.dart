import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/complaint_bloc/complaint_bloc.dart';

//Control the screen display state. Either viewOnly or allow responding
enum ComplaintStatus {
  viewOnly, // Before writing the reply
  responding, // After writing the reply
}

class ComplaintDetailsDialog extends StatelessWidget {
  const ComplaintDetailsDialog({
    super.key,
    this.status = ComplaintStatus.viewOnly, //Default value
    required this.complaint,
  });

  final ComplaintStatus status;

  final ComplaintModel complaint;

  @override
  Widget build(BuildContext context) {
    final complaintBloc = context.read<ComplaintBloc>();
    final isResponding = complaint.isActive
        ? true
        : false; //Activate writing and button.
    double width = context.getWidth(multiplied: 0.1);

    return Dialog(
      //size dialog
      child: Container(
        width: context.getWidth(multiplied: 0.5),
        height: context.getHeight(multiplied: 0.65),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Complaint data (address and date of request)
                Text("Complaint Details", style: AppTextStyle.sfProBold40),
                const SizedBox(height: 24),
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Req-${complaint.requestId!.substring(0, 5)}',
                          style: AppTextStyle.sfProBold24,
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                    _buildStatusBox(),
                  ],
                ),
                const SizedBox(height: 24),

                // Driver, patient, number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabeledText(
                      "Driver",
                      '${complaint.driver?.fullName}',
                    ),
                    _buildLabeledText("Patient", '${complaint.user?.fullName}'),
                    _buildLabeledText(
                      "Patient’s number",
                      "${complaint.user?.phoneNumber}",
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Complaint the Patient ( Read Only )
                const Text("Complaint", style: AppTextStyle.sfProBold16),

                const SizedBox(height: 8),
                _buildReadonlyBox(complaint.complaint),
                const SizedBox(height: 24),

                // Response
                const Text("Response", style: AppTextStyle.sfProBold16),
                const SizedBox(height: 8),
                _buildResponseBox(
                  isEnabled: isResponding,
                  controller: complaintBloc.responseController,
                  complaintBloc: complaintBloc,
                ),
                const SizedBox(height: 32),

                // Submit button
                BlocBuilder<ComplaintBloc, ComplaintState>(
                  builder: (context, state) {
                    final isActive = state is SuccessTypingResponseState
                        ? true
                        : false;

                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isActive
                            ? () {
                                complaintBloc.add(
                                  SendingResponseToUserEvent(
                                    response:
                                        complaintBloc.responseController.text,
                                    complaint: complaint,
                                  ),
                                );

                                

                                context.pop();
                              }
                            : null,
                        //The button is automatically disabled if the status is not responding
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isResponding //Changes based on condition
                              ? AppColors.primaryButtonColor
                              : AppColors.secondaryButtonColor,
                          disabledForegroundColor: Colors.white,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Submit Response",
                          style: AppTextStyle.sfProBold20,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //status for Complaint
  static Widget _buildStatusBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.completedBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Completed",
        style: AppTextStyle.sfProBold14.copyWith(
          color: AppColors.completedForegroundColor,
        ),
      ),
    );
  }

  // Label-value Color widget
  Widget _buildLabeledText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.sfProBold14),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyle.sfPro60014TernaryColor),
      ],
    );
  }

  // Static complaint box
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

  // Response field
  Widget _buildResponseBox({
    required bool isEnabled,
    required TextEditingController controller,
    required ComplaintBloc complaintBloc,
  }) {
    return TextFormField(
      //Specifies whether the user can type into the field or not
      enabled: isEnabled,
      // initialValue: isEnabled ? '' : "We’re really sorry...",
      maxLines: 5,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: controller,
      decoration: InputDecoration(
        hintText: isEnabled ? 'Write your response...' : null,
        hintStyle: AppTextStyle.sfProRegular14.copyWith(
          color: AppColors.secondaryTextColor,
        ),
        filled: true,
        fillColor: const Color(0xFFF1F3F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      style: isEnabled
          ? AppTextStyle.sfProMedium14.copyWith(color: Colors.black)
          : AppTextStyle.sfProMedium14.copyWith(
              color: AppColors.secondaryTextColor,
            ),

      onFieldSubmitted: (value) {
        complaintBloc.add(DoneTypingResponseEvent());
      },
    );
  }
}
