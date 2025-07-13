import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/model/charity_model/charity_model.dart';
import 'package:halaqat_wasl_manager_app/repo/auth/auth.dart';
import 'package:halaqat_wasl_manager_app/repo/charity/charity_operation_repo.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final charityNameController = TextEditingController();
  final charityNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  final GlobalKey<FormState> logInKey = GlobalKey<FormState>();

  // -- Handle the UI
  bool isShowPassword = false;
  
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });


    // -- Handling UI
    on<TogglePasswordViabilityEvent>((event, emit) {
      isShowPassword = !isShowPassword;
      emit(SuccessTogglingPasswordViability());
    });

    on<SignUpEvent>(signUp);

    on<LogInEvent>(loginEvent);
    
  }

  FutureOr<void> signUp(SignUpEvent event, Emitter<AuthState> emit) async {

    final email = emailController.text;
    final password = passwordController.text;

    try {

      emit(LoadingState());

      if (email.trim().isEmpty || password.trim().isEmpty) {
        throw 'Email and password must not be empty';
      }

      final res = await AuthRepo.signUp(email: email, password: password);

      final CharityModel charity = CharityModel(
        charityId: res.user!.id, 
        charityNumber: charityNumberController.text, 
        charityName: charityNameController.text , 
        role: 'charity', 
        charityLat: null, 
        charityLong: null, 
        totalServices: 0
      );

      // -- Inserting a record in charity table
      await CharityOperationRepo.insertingNewCharityIntoDB(charity:  charity);

      // -- inject the user data
      GetIt.I.get<CharityData>().charity = charity;

      emit(SuccessState(successMessage: 'Welcome ${charity.charityName}'));

      if(!isClosed) clearControllers();

    } catch (error) {

      emit(ErrorState(errorMessage: error.toString()));
      if (!isClosed) clearControllers();
    }
  }


  FutureOr<void> loginEvent(LogInEvent event, Emitter<AuthState> emit) async {

    final email = emailController.text;
    final password = passwordController.text;

    try{

      emit(LoadingState());
      
      if (email.trim().isEmpty || password.trim().isEmpty) {
        throw 'Email and password must not be empty';
      }

      
      await AuthRepo.logIn(email: email, password: password);
      
      final charity = await CharityOperationRepo.gettingCharityDataFromDB();

      GetIt.I.get<CharityData>().charity = charity;

      emit(SuccessState(successMessage: 'Welcome ${charity.charityName}'));
      if (!isClosed) clearControllers();

    }catch(error){
      emit(ErrorState(errorMessage: error.toString()));
      if (!isClosed) clearControllers();
    }

  }


    void clearControllers() {
    charityNameController.clear();
    emailController.clear();
    passwordController.clear();
    charityNumberController.clear();
  }
    @override
  Future<void> close() {
    charityNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    charityNumberController.dispose();
    return super.close();
  }
}
