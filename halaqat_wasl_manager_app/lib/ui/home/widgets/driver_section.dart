import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_custom_button.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/driver_bloc/driver_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/dialogs/add_driver_dialog.dart';

class DriverSection extends StatelessWidget {
  const DriverSection({
    super.key,
    required this.headerLabel,
    required this.viewAllLabel,
    required this.emptyWidget,
    this.children,
  });

  final String headerLabel;
  final String viewAllLabel;
  final Widget emptyWidget;
  
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {

    final driverBloc = context.read<DriverBloc>();

    return Column(
      children: [
        SizedBox(
          width: context.getWidth(multiplied: 0.28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(tr(headerLabel), style: AppTextStyle.sfProBold32),
            ],
          ),
        ),

        Gap.gapH8,

        Container(
          width: context.getWidth(multiplied: 0.3),
          padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children:  children ?? [emptyWidget],
                ),

                Gap.gapH24,

                AppCustomButton(
                  label: tr('home_screen.add_driver'), 
                  buttonColor: AppColors.primaryAppColor, 
                  width: context.getWidth(), 
                  height: context.getHeight(multiplied: 0.04), 
                  onPressed: (){
                    showDialog(
                      context: context, 
                      useRootNavigator: false,
                      builder: (_){
                        return  BlocProvider.value(
                            value: driverBloc,
                            child: AddDriverDialog(),
                          );
                      }
                    );
                  }
                )
              ],
            )
          ),
        ),
      ],
    );
  }
}
