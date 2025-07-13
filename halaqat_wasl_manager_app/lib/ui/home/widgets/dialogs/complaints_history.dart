import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/complaint_data.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/complaint_bloc/complaint_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/complaint_chip.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/complaint_history_chi.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/date_range_chip.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/history_chip.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/shared/search_textfield.dart';

class ComplaintsHistory extends StatelessWidget {
  const ComplaintsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final complaintBloc = context.read<ComplaintBloc>()..add(ChangeDataRangeEvent(index: 0));

    return DefaultTabController(
      length: 5,
      child: Dialog(
        child: Container(
          width: context.getWidth(multiplied: 0.52),
          height: context.getHeight(multiplied: 0.6),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: AppColors.appBackgroundColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('complaint_history_dialog.complaint_history'),
                  style: AppTextStyle.sfProBold40,
                ),

                Gap.gapH24,

                SearchTextfield(
                  label: 'Complaint Number',
                  onChange: (value) => complaintBloc.add(
                    SearchForComplaintEvent(complaintId: value),
                  ),
                ),

                Gap.gapH16,

                BlocBuilder<ComplaintBloc, ComplaintState>(
                  builder: (context, state) {
                    return TabBar(
                      indicatorColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      onTap: (value) {},
                      tabs: [
                        DateRangeChip(
                          label: '7 Days',
                          tabIndex: 0,
                          selectedIndex: complaintBloc.selectedIndex,
                        ),
                        DateRangeChip(
                          label: '14 Days',
                          tabIndex: 1,
                          selectedIndex: complaintBloc.selectedIndex,
                        ),
                        DateRangeChip(
                          label: '30 Days',
                          tabIndex: 2,
                          selectedIndex: complaintBloc.selectedIndex,
                        ),
                        DateRangeChip(
                          label: '60 Days',
                          tabIndex: 3,
                          selectedIndex: complaintBloc.selectedIndex,
                        ),
                        DateRangeChip(
                          label: '90 Days',
                          tabIndex: 4,
                          selectedIndex: complaintBloc.selectedIndex,
                        ),
                      ],
                    );
                  },
                ),

                Gap.gapH24,

                BlocBuilder<ComplaintBloc, ComplaintState>(
                  builder: (context, state) {
                    List<ComplaintModel> list = [];

                    if (state is SuccessSearchingForComplaints) {
                      list = state.complaints;
                    } else if (state is SuccessState) {
                      list = GetIt.I.get<ComplaintData>().complaints;
                    }

                    return GridView.builder(
                      itemCount: list.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 40,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ComplaintHistoryChip(
                        complaint: list[index],
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
}
