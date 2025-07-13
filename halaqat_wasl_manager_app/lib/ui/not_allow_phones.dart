import 'package:flutter/material.dart';
import 'package:halaqat_wasl_manager_app/theme/app_text_style.dart';

class NotAllowPhones extends StatelessWidget {
  const NotAllowPhones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('You need to use an iPad to use this app', style: AppTextStyle.sfPro60036,)),
    );
  }
}