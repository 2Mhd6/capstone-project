import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';

import 'package:halaqat_wasl_manager_app/data/complaint_data.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/repo/charity/charity_complaints_repo.dart';
import 'package:meta/meta.dart';

part 'complaint_event.dart';
part 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  int selectedIndex = 0;
  List<int> complaints = [];

  final TextEditingController responseController = TextEditingController();

  ComplaintBloc() : super(ComplaintInitial()) {
    on<ComplaintEvent>((event, emit) {});

    on<GettingAllComplaintsEvent>(getComplaints);
    on<SendingResponseToUserEvent>(sendingResponseToUser);
    on<ChangeDateRangeEvent>(changeDateRangeEvent);
    on<GettingComplaintDataBasedOnDate>(gettingDateBasedOnDate);
    on<DoneTypingResponseEvent>((event, emit) => emit(SuccessTypingResponseState()));
    on<SearchForComplaintEvent>(searchForComplaint);
  }

  FutureOr<void> changeDateRangeEvent(
    ChangeDateRangeEvent event,
    Emitter<ComplaintState> emit,
  ) {
    emit(LoadingState());
    selectedIndex = event.selectedIndex;
    emit(SuccessState(successMessage: 'Date changes'));
  }

  FutureOr<void> gettingDateBasedOnDate(
    GettingComplaintDataBasedOnDate event,
    Emitter<ComplaintState> emit,
  ) async {
    emit(LoadingState());

    await Future.delayed(Duration(milliseconds: 700));

    switch (selectedIndex) {
      case 0:
        complaints = List.generate(7, (index) => index);

      case 1:
        complaints = List.generate(14, (index) => index);

      case 2:
        complaints = List.generate(30, (index) => index);

      case 3:
        complaints = List.generate(60, (index) => index);

      case 4:
        complaints = List.generate(90, (index) => index);
    }

    emit(SuccessState(successMessage: 'Check - gettingDateBasedOnDate'));
  }

  FutureOr<void> getComplaints(GettingAllComplaintsEvent event,Emitter<ComplaintState> emit) async {

    emit(LoadingState());

    final complaintsData = GetIt.I.get<ComplaintData>();

    try {
      final allComplaints = await CharityComplaintsRepo.gettingAllComplaints();

      // For show all complaints in the complaints dialog
      complaintsData.complaints = allComplaints;

      // For showing all the active complaints in the home screen
      complaintsData.activeComplaints = allComplaints
          .where((complaint) => complaint.isActive)
          .toList();

      emit(SuccessState(successMessage: 'Getting all complaints'));
    } catch (error) {
      emit(ErrorState(errorMessage: error.toString()));
    }
  }

  FutureOr<void> sendingResponseToUser(SendingResponseToUserEvent event, Emitter<ComplaintState> emit) async{

    emit(LoadingState());

    final activeComplaints = GetIt.I.get<ComplaintData>().activeComplaints;
    final currentComplaint = event.complaint;
    final index = activeComplaints.indexOf(currentComplaint);

    final response = event.response;

    try{
      await CharityComplaintsRepo.responseToUser(response: response, complaintId: currentComplaint.complaintId);
      emit(SuccessSendingResponseToUser());
      activeComplaints.removeAt(index);
      if(!isClosed) clear();
    }catch(error){
      emit(ErrorState(errorMessage: error.toString()));
      if (!isClosed) clear();
    }
  }


  void clear(){
    responseController.clear();
  }

  @override
  Future<void> close() {
    responseController.dispose();
    return super.close();
  }

  FutureOr<void> searchForComplaint(
    SearchForComplaintEvent event,
    Emitter<ComplaintState> emit,
  ) async {
    final keyword = event.complaintId.trim().toLowerCase();
    final allComplaints = GetIt.I.get<CharityData>().complaintsHistory;

    if (keyword.isEmpty) {
      emit(SuccessSearchingForComplaints(complaints: allComplaints));
      return;
    }

    final filteredComplaints = allComplaints.where((complaint) {
      final complaintId = complaint.complaint.toLowerCase();
      return complaintId.substring(0, 5).contains(keyword);
    }).toList();

    emit(SuccessSearchingForComplaints(complaints: filteredComplaints));
  } 
}
