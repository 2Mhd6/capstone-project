part of 'driver_bloc.dart';

@immutable
sealed class DriverState {}

final class DriverInitial extends DriverState {}

final class LoadingGettingDriversState extends DriverState {}

final class SuccessGettingAllDrivers extends DriverState{}

final class SuccessGettingAllAvailableDrivers extends DriverState{}

final class SuccessAddingNewDriverState extends DriverState {
  final String successMessage; 

  SuccessAddingNewDriverState({required this.successMessage});
}
final class ErrorState extends DriverState{

  final String errormessage;
  ErrorState({required this.errormessage});

}
