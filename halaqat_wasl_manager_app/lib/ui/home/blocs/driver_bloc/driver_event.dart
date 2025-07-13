part of 'driver_bloc.dart';

@immutable
sealed class DriverEvent {}

final class GettingAllDriversEvent extends DriverEvent{}

final class GettingAvailableDriversEvent extends DriverEvent{
  final RequestModel request;
  GettingAvailableDriversEvent({required this.request});
}

final class AddNewDriverEvent extends DriverEvent{}

