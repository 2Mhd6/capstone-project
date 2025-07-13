part of 'request_bloc.dart';

@immutable
sealed class RequestEvent {}

final class FetchingDataFromDBEvent extends RequestEvent{}

final class StreamingDataFromDBEvent extends RequestEvent{}

final class SelectingDriverForRequest extends RequestEvent{}

final class AssigningRequestToDriverEvent extends RequestEvent{
  final RequestModel request;
  final DriverModel driver;

  AssigningRequestToDriverEvent({required this.request, required this.driver});
}

final class FetchingAllHistoryRequestFromDB extends RequestEvent{}

final class SearchForRequestEvent extends RequestEvent{
  final String requestID;

  SearchForRequestEvent({required this.requestID});
}

final class ChangeDataRangeRequestEvent extends RequestEvent{
  final int index;
  ChangeDataRangeRequestEvent({required this.index});
}

