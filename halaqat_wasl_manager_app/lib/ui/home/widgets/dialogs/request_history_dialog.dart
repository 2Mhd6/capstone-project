import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/request_bloc/request_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/date_range_chip.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/history_chip.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/shared/search_textfield.dart';

class RequestHistoryDialog extends StatelessWidget {
  const RequestHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {

    final requestBloc = context.read<RequestBloc>()..add(ChangeDataRangeRequestEvent(index: 0));
    final historyRequests = GetIt.I.get<CharityData>().requestHistory;
    
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
                  tr('request_history_dialog_home_screen.request_history'),
                  style: AppTextStyle.sfProBold40,
                ),

                Gap.gapH24,

                SearchTextfield(
                  label: 'request_history_dialog_home_screen.search_number_request',
                  onChange: (value) => requestBloc.add(SearchForRequestEvent(requestID: value)),
                ),

                Gap.gapH16,

                BlocBuilder<RequestBloc, RequestState>(
                  builder: (context, state) {
                    return TabBar(
                      indicatorColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      onTap: (value) async{
                        requestBloc.add(
                          ChangeDataRangeRequestEvent(index: value));
                        await Future.delayed(Duration(milliseconds: 600));
                      },
                      tabs: [
                        DateRangeChip(
                          label: '7 Days',
                          tabIndex: 0,
                          selectedIndex: requestBloc.selectedIndex,
                        ),
                        DateRangeChip(
                          label: '14 Days',
                          tabIndex: 1,
                          selectedIndex: requestBloc.selectedIndex,
                        ),
                        DateRangeChip(
                          label: '30 Days',
                          tabIndex: 2,
                          selectedIndex: requestBloc.selectedIndex,
                        ),
                        DateRangeChip(
                          label: '60 Days',
                          tabIndex: 3,
                          selectedIndex: requestBloc.selectedIndex,
                        ),
                        DateRangeChip(
                          label: '90 Days',
                          tabIndex: 4,
                          selectedIndex: requestBloc.selectedIndex,
                        ),
                      ],
                    );
                  },
                ),

                Gap.gapH16,

                BlocBuilder<RequestBloc, RequestState>(
                  builder: (context, state) {
                    
                    if (state is LoadingRequestState) {
                      return SizedBox(
                        width: context.getWidth(),
                        height: context.getHeight(multiplied: 0.3),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    List<RequestModel> requests = [];

                    if(state is SuccessChangingDateForRequestHistory){
                      requests = state.requests;
                    }

                    if(state is SuccessSearchingForRequest){
                      requests = state.requests;
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            Gap.gapW24,
                            Text(
                              'Total Records: ${requests.length}',
                              style: AppTextStyle.sfProBold13.copyWith(
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),

                        Gap.gapH24,

                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 20,
                                childAspectRatio: 3,
                              ),
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            return HistoryChip(request: requests[index],state: requests[index].status);
                          },
                        ),
                      ],
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
