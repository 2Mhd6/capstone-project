import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/data/complaint_data.dart';
import 'package:halaqat_wasl_manager_app/data/supabase_data.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/complaint_bloc/complaint_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/driver_bloc/driver_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/request_bloc/request_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/statistic_bloc/statistic_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/chips/statistic_chip.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final requestBloc = context.read<RequestBloc>();
    final driverBloc = context.read<DriverBloc>();
    final complaintBloc = context.read<ComplaintBloc>();
    final statisticBloc = context.read<StatisticBloc>();
    final charity = GetIt.I.get<CharityData>();
    final complaints = GetIt.I.get<ComplaintData>();
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr('home_screen.welcome', args: [charity.charity.charityName]),
              style: AppTextStyle.sfProBold40,
            ),

            Row(
              children: [
                IconButton(
                  onPressed: () {
                    requestBloc.add(FetchingDataFromDBEvent());
                    driverBloc.add(GettingAllDriversEvent());
                    statisticBloc.add(GettingStatisticEvent());
                    complaintBloc.add(GettingAllComplaintsEvent());
                  },
                  icon: Icon(Icons.refresh),
                ),

                IconButton(
                  onPressed: () =>
                      GetIt.I.get<SupabaseData>().supabase..auth.signOut(),
                  icon: Icon(Icons.logout_outlined, color: Colors.red),
                ),
              ],
            ),
          ],
        ),

        Gap.gapH40,

        BlocBuilder<StatisticBloc, StatisticState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatisticChip(
                  label: 'home_screen.total_services',
                  statistic: (charity.charity.totalServices ?? 0).toString(),
                  imagePath: 'assets/home/chart.png',
                ),
                StatisticChip(
                  label: 'home_screen.total_complaints',
                  statistic: (complaints.complaints.length).toString(),
                  imagePath: 'assets/home/error.png',
                ),
                StatisticChip(
                  label: 'home_screen.active_complaints',
                  statistic: complaints.activeComplaints.length.toString(),
                  imagePath: 'assets/home/error.png',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
