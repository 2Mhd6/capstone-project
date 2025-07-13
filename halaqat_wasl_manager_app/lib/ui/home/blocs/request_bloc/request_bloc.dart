import 'dart:async';
import 'dart:developer';


import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/data/request_data.dart';
import 'package:halaqat_wasl_manager_app/model/charity_model/charity_model.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/repo/charity/requests_repo.dart';

import 'package:meta/meta.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  
  int selectedIndex = 0;

  RequestBloc() : super(RequestInitial()) {

    on<RequestEvent>((event, emit) {});

    on<FetchingDataFromDBEvent>(fetchingDataFromDB);

    on<SelectingDriverForRequest>(
      (event, emit) => emit(SuccessSelectingDriverForRequestState()),
    );

    on<AssigningRequestToDriverEvent>(assigningRequestToDriver);

    on<FetchingAllHistoryRequestFromDB>(fetchingHistory);

    on<SearchForRequestEvent>(searchForRequest);

    on<ChangeDataRangeRequestEvent>(changeDateRange);

    
  }

  FutureOr<void> fetchingDataFromDB(
    FetchingDataFromDBEvent event,
    Emitter<RequestState> emit,
  ) async {
    emit(LoadingRequestState());

    final charity = GetIt.I.get<CharityData>();
    final requests = GetIt.I.get<RequestData>();

    requests.pendingRequests = [];

    try {
      final List<RequestModel> allPendingRequest =
          await RequestsRepo.gettingAllPendingRequests();

      final List<RequestModel> requestFilteredByTenKM = filterRequestsUpToTenKM(
        requests: allPendingRequest,
        charity: charity.charity,
      );

      requests.pendingRequests = requestFilteredByTenKM;

      emit(SuccessFetchingRequestDataFromDBState());
    } catch (error) {
      emit(ErrorFetchingRequestDataFromDBState(message: error.toString()));
    }
  }

  FutureOr<void> assigningRequestToDriver(
    AssigningRequestToDriverEvent event,
    Emitter<RequestState> emit,
  ) async {
    final request = event.request;
    final driver = event.driver;

    try {
      await RequestsRepo.assigningRequestToDriver(
        request: request,
        driverId: driver.driverId,
      );
      emit(SuccessAssigningDriverToRequestState());
    } catch (error) {
      emit(ErrorAssigningDriverToRequestState(message: error.toString()));
    }
  }

  List<RequestModel> filterRequestsUpToTenKM({
    required List<RequestModel> requests,
    required CharityModel charity,
  }) {
    final charityLat = charity.charityLat;
    final charityLong = charity.charityLong;

    return requests.where((request) {
      double distanceInMeters = Geolocator.distanceBetween(
        charityLat!,
        charityLong!,
        request.pickupLat,
        request.pickupLong,
      );

      double distanceInKm = distanceInMeters / 1000;
      return distanceInKm <= 10;
    }).toList();
  }

  FutureOr<void> fetchingHistory(
    FetchingAllHistoryRequestFromDB event,
    Emitter<RequestState> emit,
  ) async {
    emit(LoadingRequestState());

    try {
      GetIt.I.get<CharityData>().requestHistory =
          await RequestsRepo.gettingAllRequests();
      emit(SuccessFetchingHistoryRequestDataFromDBState());
    } catch (error) {
      emit(
        ErrorFetchingHistoryRequestDataFromDBState(message: error.toString()),
      );
    }
  }

FutureOr<void> searchForRequest(
    SearchForRequestEvent event,
    Emitter<RequestState> emit,
  ) {
    emit(LoadingRequestState());

    selectedIndex = -1;

    final query = event.requestID.toLowerCase().trim();

    // Get the full request history
    List<RequestModel> requestsHistory = GetIt.I
        .get<CharityData>()
        .requestHistory;

    // If query is empty, just return the full list or an empty list as needed
    if (query.isEmpty) {
      emit(SuccessSearchingForRequest(requests: requestsHistory));
    }

    // Filter requests by checking if requestId contains the query (case-insensitive)
    final filteredRequests = requestsHistory.where((request) {
      final requestId = request.requestId.toLowerCase();
      return requestId.substring(0,5).contains(query);
    }).toList();

    emit(SuccessSearchingForRequest(requests: filteredRequests));
  }

  FutureOr<void> changeDateRange(
    ChangeDataRangeRequestEvent event,
    Emitter<RequestState> emit,
  ) {

    emit(LoadingRequestState());

    selectedIndex = event.index;
    int days = 0;
    List<RequestModel> allRequests = GetIt.I.get<CharityData>().requestHistory;
    log('-djfojsfjsodjfjsdf--\n$allRequests');
    

    switch (selectedIndex) {
      case 0:
        days = 7;

      case 1:
        days = 14;

      case 2:
        days = 30;

      case 3:
        days = 60;

      case 4:
        days = 90;
    }

    final now = DateTime.now();
    final fromDate = now.subtract(Duration(days: days));

    allRequests = allRequests.where((request) => request.requestDate.isAfter(fromDate) && request.requestDate.isBefore(now)).toList();
    

    emit(SuccessChangingDateForRequestHistory(requests: allRequests));

  }
}
