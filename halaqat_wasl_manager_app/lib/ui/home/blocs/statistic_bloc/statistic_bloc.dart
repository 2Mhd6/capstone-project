import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/data/complaint_data.dart';
import 'package:halaqat_wasl_manager_app/repo/charity/charity_complaints_repo.dart';
import 'package:halaqat_wasl_manager_app/repo/charity/charity_operation_repo.dart';
import 'package:meta/meta.dart';

part 'statistic_event.dart';
part 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {

  StatisticBloc() : super(StatisticInitial()) {

    on<StatisticEvent>((event, emit) {});

    on<GettingStatisticEvent>(getStatistic);
  
  }

  FutureOr<void> getStatistic(
    GettingStatisticEvent event, Emitter<StatisticState> emit) async {

    emit(LoadingStatisticState());
    try{
      
      final allComplaints = await CharityComplaintsRepo.gettingAllComplaints();
      GetIt.I.get<ComplaintData>().complaints = allComplaints;
      GetIt.I.get<ComplaintData>().activeComplaints = allComplaints.where((complaint) => complaint.isActive).toList();

      final charityDataFromDB = await CharityOperationRepo.gettingCharityDataFromDB();
       GetIt.I.get<CharityData>().charity.totalServices = charityDataFromDB.totalServices;

      emit(SuccessState(successMessage: '${charityDataFromDB.charityName}\'s statistic is updated'));

    }catch(error){
      emit(ErrorState(errorMessage: error.toString()));
    }
  }
}
