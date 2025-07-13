part of 'complaint_bloc.dart';

@immutable
sealed class ComplaintEvent {}

final class GettingAllComplaintsEvent extends ComplaintEvent{}

final class SendingResponseToUserEvent extends ComplaintEvent{
  final String response;
  final ComplaintModel complaint;

  SendingResponseToUserEvent({required this.response,required this.complaint});
}

final class DoneTypingResponseEvent extends ComplaintEvent{}

final class ChangeDateRangeEvent extends ComplaintEvent {
  final int selectedIndex;
  ChangeDateRangeEvent({required this.selectedIndex});
}

final class GettingComplaintDataBasedOnDate extends ComplaintEvent{}

final class FetchingAllHistoryComplaintFromDB extends ComplaintEvent {}

final class SearchForComplaintEvent extends ComplaintEvent {
  final String complaintId;

  SearchForComplaintEvent({ required this.complaintId});
}

final class ChangeDataRangeEvent extends ComplaintEvent {
  final int index;
  ChangeDataRangeEvent({required this.index});
}
