import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/repo/charity/charity_operation_repo.dart';
import 'package:halaqat_wasl_manager_app/shared/set_up.dart';
import 'package:halaqat_wasl_manager_app/ui/auth/log_in_screen.dart';
import 'package:halaqat_wasl_manager_app/ui/auth/sign_up_screen.dart';
import 'package:halaqat_wasl_manager_app/ui/home/home_screen.dart';
import 'package:halaqat_wasl_manager_app/ui/not_authorized.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key, this.whereYouWantToGo});

  final String? whereYouWantToGo;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: SetupSupabase.sharedSupabase.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        
        if (whereYouWantToGo == 'sign_up') {
          return SignUpScreen();
        } else if (whereYouWantToGo == 'log_in') {
          return LogInScreen();
        }

        final authState = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (authState == null || authState.session == null) {
          return LogInScreen();
        }

        

        return FutureBuilder(
          future: CharityOperationRepo.gettingCharityDataFromDB(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (userSnapshot.hasError || !userSnapshot.hasData) {
              return NotAuthorized();
            }

            final charity = userSnapshot.data!;
            final role = charity.role;

            GetIt.I.get<CharityData>().charity = charity;

            if (role == 'charity') {
              return HomeScreen();
            } 

            return CircularProgressIndicator();
          },
        );
      },
    );
  }
}
