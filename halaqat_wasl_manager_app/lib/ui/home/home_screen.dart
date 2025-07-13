import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/data/complaint_data.dart';
import 'package:halaqat_wasl_manager_app/data/driver_data.dart';
import 'package:halaqat_wasl_manager_app/data/request_data.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/helpers/formatted_date.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/complaint_bloc/complaint_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/driver_bloc/driver_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/request_bloc/request_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/statistic_bloc/statistic_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/complaint_chip.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/complaint_details_dialog.dart.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/driver_chip.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/complaints_history.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/request_details_dialog.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/request_history_dialog.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/driver_section.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/empty_widget.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/header_section.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/main_section.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/request_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RequestBloc()..add(FetchingDataFromDBEvent())),
        BlocProvider(create: (context) => DriverBloc()..add(GettingAllDriversEvent())),
        BlocProvider(create: (context) => ComplaintBloc()..add(GettingAllComplaintsEvent())),
        BlocProvider(create: (context) => StatisticBloc()..add(GettingStatisticEvent())),
      ],
      child: Builder(
        builder: (context) {

          final requestBloc = context.read<RequestBloc>();
          final driverBloc = context.read<DriverBloc>();
          final complaintBloc = context.read<ComplaintBloc>();
          final statisticBloc = context.read<StatisticBloc>();
          final charity = GetIt.I.get<CharityData>();
          final requests = GetIt.I.get<RequestData>();
          final drivers =  GetIt.I.get<DriverData>();
          final complaints = GetIt.I.get<ComplaintData>();

          return Scaffold(
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.only(left: 32, right: 32, top: 50),
                width: context.getWidth(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: statisticBloc),
                          BlocProvider.value(value: requestBloc),
                          BlocProvider.value(value: driverBloc),
                          BlocProvider.value(value: complaintBloc)
                        ], 
                        child: HeaderSection()
                      ),

                      Gap.gapH56,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Request Section ---
                          MainSection(
                            headerLabel: 'home_screen.requests',
                            onPressedViewAll: () async{
                              
                              showDialog(
                                context: context,
                                barrierDismissible:false, // prevent closing while loading
                                builder: (_) =>Center(child: CircularProgressIndicator()),
                              );

                              requestBloc.add(FetchingAllHistoryRequestFromDB());
                              requestBloc.add(ChangeDataRangeRequestEvent(index: 0));
                              
                              await Future.delayed(Duration(milliseconds:800));

                              if(context.mounted){
                                context.pop();
                                
                                showDialog(context: context, builder: (context){
                                  return BlocProvider.value(
                                    value: requestBloc,
                                    child: RequestHistoryDialog(),
                                  );
                                  }
                                );
                              }},
                            children: [
                              Gap.gapH16,

                              BlocBuilder<RequestBloc, RequestState>(
                                builder: (context, state) {

                                  
                              if(requests.pendingRequests.isEmpty){
                                return EmptyWidget(label: 'requests');
                              }

                              if(state is LoadingRequestState) {
                                return Center(child: CircularProgressIndicator());
                              }

                                

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: requests.pendingRequests.length,
                                    itemBuilder: (context, index){
                                      return RequestChip(request: requests.pendingRequests[index], onPressed: () async {
                                        log('${drivers.availableDrivers}');
                                        // Setting up a request
                                        final request = requests.pendingRequests[index];
                                        driverBloc.add(GettingAvailableDriversEvent(request: request));
                                        final formattedDate = FormattedDate.formattedDataForRequestDetails(request.requestDate);
                                        await Future.delayed(Duration(milliseconds: 600));

                                        

                                        

                                        log('${drivers.availableDrivers}');
                                        if(context.mounted){
                                          showDialog(context: context, builder: (context){
                                            return BlocProvider.value(
                                              value: requestBloc,
                                              child: RequestDetailsDialog(
                                                request: request, 
                                                availableDrivers: drivers.availableDrivers, 
                                                formattedDate: formattedDate,
                                              ),
                                            );
                                          });
                                        }
                                      });
                                    }
                                  );
                                },
                              ),
                            ],
                          ),

                          // --- Driver Section ---
                          BlocProvider.value(
                            value: driverBloc,
                            child: DriverSection(
                              headerLabel: 'home_screen.drivers',
                              viewAllLabel: 'home_screen.view_all',
                              emptyWidget: Center(
                                child: Text('Wow I think it\'s  empty for now'),
                              ),
                              children: [

                                Gap.gapH16,

                                BlocBuilder<DriverBloc, DriverState>(
                                  builder: (context, state) {
                                    if (drivers.drivers.isEmpty)
                                      EmptyWidget(label: 'drivers');

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: drivers.drivers.length,
                                      itemBuilder: (context, index) {
                                        return DriverChip(
                                          driver: drivers.drivers[index],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          // --- Complaints Section ---
                          MainSection(
                            headerLabel: 'home_screen.complaints',
                            onPressedViewAll: () async{
                              
                              showDialog(
                                context: context,
                                barrierDismissible:false, // prevent closing while loading
                                builder: (_) =>Center(child: CircularProgressIndicator()),
                              );

                              complaintBloc.add(FetchingAllHistoryComplaintFromDB());
                              complaintBloc.add(ChangeDataRangeEvent(index: 0));
                              
                              await Future.delayed(Duration(milliseconds:800));

                              if(context.mounted){
                                context.pop();
                                
                                showDialog(context: context, builder: (context){
                                  return BlocProvider.value(
                                    value: complaintBloc,
                                    child: ComplaintsHistory(),
                                  );
                                  }
                                );
                              }
                            },
                            children: [
                            
                              Gap.gapH16,
                              Column(
                                children: [
                                  BlocBuilder<ComplaintBloc, ComplaintState>(
                                    builder: (context, state) {
                                      
                                      if (complaints.activeComplaints.isEmpty)
                                        return EmptyWidget(label: 'complaints');

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            complaints.activeComplaints.length,
                                        itemBuilder: (context, index) {
                                          return ComplaintChip(
                                            complaint:complaints.activeComplaints[index],
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return BlocProvider.value(
                                                    value: complaintBloc,
                                                    child: ComplaintDetailsDialog(
                                                      complaint: complaints.activeComplaints[index],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
