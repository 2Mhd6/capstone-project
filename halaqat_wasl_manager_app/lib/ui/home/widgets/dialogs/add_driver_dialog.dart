import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/helpers/validator.dart';
import 'package:halaqat_wasl_manager_app/shared/nav.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_custom_button.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/app_snack_bart.dart';
import 'package:halaqat_wasl_manager_app/shared/widgets/gap.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';
import 'package:halaqat_wasl_manager_app/ui/home/blocs/driver_bloc/driver_bloc.dart';
import 'package:halaqat_wasl_manager_app/ui/home/widgets/shared/app_custom_textfield.dart';

class AddDriverDialog extends StatelessWidget {
  const AddDriverDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final driverBloc = context.read<DriverBloc>();
    return BlocListener<DriverBloc, DriverState>(
      listener: (context, state) {
        if(state is SuccessAddingNewDriverState){
          appSnackBar(context: context, message: state.successMessage, isSuccess: true);
        }else if (state is ErrorState){
          appSnackBar(context: context, message: state.errormessage, isSuccess: false);
        }
      },
      child: Dialog(
        child: Container(
          width: context.getWidth(multiplied: 0.5),
          height: context.getHeight(multiplied: 0.5),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.secondaryButtonColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: driverBloc.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add New Driver", style: AppTextStyle.sfProBold40),

                  Gap.gapH24,

                  AppCustomTextfield(
                    label: tr('add_driver_dialog_home_screen.full_name'),
                    controller: driverBloc.fullNameController,
                    onValidate: fullNameValidator,
                  ),

                  AppCustomTextfield(
                    label: tr('add_driver_dialog_home_screen.email'),
                    controller: driverBloc.emailController,
                    onValidate: emailValidator,
                  ),

                  AppCustomTextfield(
                    label: tr('add_driver_dialog_home_screen.phone_number'),
                    controller: driverBloc.phoneNumberController,
                    onValidate: phoneValidator,
                    isPhoneNumber: true,
                  ),

                  AppCustomButton(
                    label: 'Add Driver',
                    buttonColor: AppColors.primaryAppColor,
                    width: context.getWidth(),
                    height: context.getHeight(multiplied: 0.04),
                    onPressed: () {
                      if (driverBloc.formKey.currentState!.validate()) {
                        driverBloc.add(AddNewDriverEvent());
                        context.pop();

                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
