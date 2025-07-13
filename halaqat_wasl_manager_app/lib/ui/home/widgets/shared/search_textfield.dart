import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/theme/app_colors.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

class SearchTextfield extends StatelessWidget {
  const SearchTextfield({super.key, required this.label, required this.onChange});

  final String label;
  final void Function(String value) onChange;
  

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColors.secondaryColor,
      cursorHeight: 16,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: tr(label),
        hintStyle: AppTextStyle.sfPro60020SecondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onChanged: onChange,
    );
  }
}
