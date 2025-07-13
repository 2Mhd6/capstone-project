import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/extensions/screen_size.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.label});

  final String label;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getHeight(multiplied: 0.4),
      width: context.getWidth(multiplied: 0.3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Center(
        child: Text('No $label found', style: AppTextStyle.sfPro60020SecondaryColor,),
      ),
    );
  }
}