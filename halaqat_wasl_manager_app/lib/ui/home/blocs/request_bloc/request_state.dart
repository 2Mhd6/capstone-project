part of 'request_bloc.dart';

@immutable
sealed class RequestState {}

final class RequestInitial extends RequestState{}

final class LoadingRequestState extends RequestState{}

final class SuccessFetchingRequestDataFromDBState extends RequestState{}

final class ErrorFetchingRequestDataFromDBState extends RequestState {
  final String message;

  ErrorFetchingRequestDataFromDBState({required this.message});
}

final class SuccessSelectingDriverForRequestState extends RequestState {}

final class SuccessAssigningDriverToRequestState extends RequestState{}

final class ErrorAssigningDriverToRequestState extends RequestState {
  final String message;

  ErrorAssigningDriverToRequestState({required this.message});
}


final class SuccessFetchingHistoryRequestDataFromDBState extends RequestState {}

final class SuccessSearchingForRequest extends RequestState{
  final List<RequestModel> requests;

  SuccessSearchingForRequest({required this.requests});
}

final class SuccessChangingDateForRequestHistory extends RequestState {
  
  final List<RequestModel> requests;
  
  SuccessChangingDateForRequestHistory({required this.requests});

}


final class ErrorFetchingHistoryRequestDataFromDBState extends RequestState {
  final String message;

  ErrorFetchingHistoryRequestDataFromDBState({required this.message});
}
