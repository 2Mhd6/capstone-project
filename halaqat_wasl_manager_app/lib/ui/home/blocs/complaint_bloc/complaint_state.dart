part of 'complaint_bloc.dart';

@immutable
sealed class ComplaintState {}

final class ComplaintInitial extends ComplaintState {}

final class LoadingState extends ComplaintState{}

final class SuccessState extends ComplaintState {
  final String successMessage;

  SuccessState({required this.successMessage});
}

final class ErrorState extends ComplaintState {
  final String errorMessage;

  ErrorState({required this.errorMessage});
}


final class SuccessSendingResponseToUser extends ComplaintState{}

final class SuccessTypingResponseState extends ComplaintState{}


final class SuccessFetchingHistoryComplaintsDataFromDBState extends ComplaintState {}

final class SuccessSearchingForComplaints extends ComplaintState {
  final List<ComplaintModel> complaints;

  SuccessSearchingForComplaints({required this.complaints});
}

final class SuccessChangingDateForComplaintHistory extends ComplaintState {
  final List<ComplaintModel> complaints;

  SuccessChangingDateForComplaintHistory({required this.complaints});
}
