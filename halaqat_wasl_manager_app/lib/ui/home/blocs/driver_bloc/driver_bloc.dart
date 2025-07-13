import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/data/driver_data.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/repo/charity/charity_drivers_repo.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  
  DriverBloc() : super(DriverInitial()) {
    on<DriverEvent>((event, emit) {});

    on<AddNewDriverEvent>(addNewDriver);

    on<GettingAllDriversEvent>(gettingAllDrivers);

    on<GettingAvailableDriversEvent>(gettingAvailableDrivers);
    
  }

  FutureOr<void> addNewDriver(AddNewDriverEvent event, Emitter<DriverState> emit) async{

    emit(LoadingGettingDriversState());
    try{
      
      final res = await CharityDriversRepo.registerNewDriver(email: emailController.text, phoneNumber: phoneNumberController.text);
      final charityId = GetIt.I.get<CharityData>().charity.charityId;

      

      final DriverModel driver = DriverModel(
        driverId: res.user!.id, 
        charityId: charityId , 
        notificationId: Uuid().v4(), 
        fullName: fullNameController.text, 
        role: 'driver', 
        status: 'available', 
        phoneNumber: '+966${phoneNumberController.text}',
        totalServices: 0
      );

      

      await CharityDriversRepo.insertingNewDriverIntoDB(driver: driver);
      emit(SuccessAddingNewDriverState(successMessage: '${fullNameController.text} has been added'));
      if(!isClosed) clear();
      
    }catch(error){
      emit(ErrorState(errormessage: error.toString()));
      if (!isClosed) clear();
    }
  }

  FutureOr<void> gettingAllDrivers(GettingAllDriversEvent event, Emitter<DriverState> emit) async {
    
    final drivers = GetIt.I.get<DriverData>();
    emit(LoadingGettingDriversState());
    try{
      drivers.drivers = await CharityDriversRepo.gettingAllDrivers();

      emit(SuccessGettingAllDrivers());

    }catch(error){
      emit(ErrorState(errormessage: error.toString()));
    }
  }




   // -- Clearing Fields
  void clear() {
    fullNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    return super.close();
  }

  FutureOr<void> gettingAvailableDrivers(GettingAvailableDriversEvent event, Emitter<DriverState> emit) async {

    emit(LoadingGettingDriversState());
    
    try{
      
      GetIt.I.get<DriverData>().availableDrivers = await CharityDriversRepo.getAvailableDrivers(event.request.requestDate);
      emit(SuccessGettingAllAvailableDrivers());
      
    }catch(error){
      log('${error.toString()}');
      emit(ErrorState(errormessage: error.toString()));
    }
  }
}




