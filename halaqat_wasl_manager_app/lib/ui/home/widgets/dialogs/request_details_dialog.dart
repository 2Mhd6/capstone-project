import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/request_bloc/request_bloc.dart';

class RequestDetailsDialog extends StatelessWidget {
  RequestDetailsDialog({
    super.key,
    required this.request,
    required this.availableDrivers,
    required this.formattedDate,
  });

  final RequestModel request;
  final List<DriverModel> availableDrivers;
  DriverModel? selectedDriver;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final requestBloc = context.read<RequestBloc>();

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
            //// request number and status
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Request Details", style: AppTextStyle.sfProBold40),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#REQ-${request.requestId.substring(0, 5).toUpperCase()}",
                        style: AppTextStyle.sfProBold24,
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                  _buildStatusBox('${request.status[0].toUpperCase() + request.status.substring(1)}'),
                ],
              ),

              const SizedBox(height: 24),
              Text(request.user!.fullName, style: AppTextStyle.sfProBold20),
              const SizedBox(height: 24),

              // Information request ( Pickup - Destination - Time )
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabeledText("Pick up", request.pickUpReadableAddress),
                  _buildLabeledText("Destination", '${request.hospital?.hospitalName}',),
                  _buildLabeledText("Time & Date", formattedDate),
                ],
              ),

              const SizedBox(height: 24),

              // Special Needs or notes ( only read )
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

              const SizedBox(height: 24),

              DropdownButtonFormField<DriverModel>(
                value: selectedDriver,
                decoration: InputDecoration(
                  hintText: (availableDrivers.isEmpty ? 'No Driver Available at this date & time' :'Select a driver'),
                  labelStyle: AppTextStyle.sfProMedium14,
                  filled: true,
                  fillColor: const Color(0xFFF1F3F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: availableDrivers.map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(d.fullName, style: AppTextStyle.sfProMedium14),
                  );
                }).toList(),
                onChanged: (driver) {
                  selectedDriver = driver;
                  requestBloc.add(SelectingDriverForRequest());
                },
              ),
              const SizedBox(height: 32),

              BlocBuilder<RequestBloc, RequestState>(
                builder: (context, state) {

                  final color = state is SuccessSelectingDriverForRequestState ? AppColors.completedButtonColor : AppColors.primaryAppColor;
                  final text = state is SuccessSelectingDriverForRequestState ? 'Let ${selectedDriver?.fullName.split(' ')[0]} take the ride' : 'Accept Request';
                  return SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: selectedDriver == null
                          ? null
                          : () {
                              requestBloc.add(
                                AssigningRequestToDriverEvent(
                                  request: request,
                                  driver: selectedDriver!,
                                ),
                              );
                              context.pop();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        text,
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
    );
  }

  //Order status in custom color according to the status
  Widget _buildStatusBox(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.pendingBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: AppTextStyle.sfProBold14.copyWith(
          color: AppColors.pendingForegroundColor,
        ),
      ),
    );
  }

  //Displays title + content
  Widget _buildLabeledText(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.sfProBold14),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.start,
          style: AppTextStyle.sfPro60012TernaryColor,
          maxLines: 2,
        ),
      ],
    );
  }

  //notes read only
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
