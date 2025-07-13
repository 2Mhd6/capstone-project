import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/shared/set_up.dart';
import 'package:halaqat_wasl_manager_app/theme/app_theme.dart';
import 'package:halaqat_wasl_manager_app/ui/auth/auth_gate_screen.dart';
import 'package:halaqat_wasl_manager_app/ui/not_allow_phones.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await dotenv.load(fileName: '.env');
  await EasyLocalization.ensureInitialized();

  await SetupSupabase.setUpSupabase();
  await EasyLocalization.ensureInitialized();

  InjectionContainer.setUp();

  GetIt.I.allReady();


  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if(constraints.maxWidth < 980){
            return NotAllowPhones();
          }else{
            return AuthGateScreen();
          }
        },
      )
    );
  }
}
