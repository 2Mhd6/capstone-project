part of 'statistic_bloc.dart';

@immutable
sealed class StatisticState {}

final class StatisticInitial extends StatisticState {}

final class LoadingStatisticState extends StatisticState{}

final class SuccessState extends StatisticState {
  final String successMessage;

  SuccessState({required this.successMessage});
}

final class ErrorState extends StatisticState {
  final String errorMessage;

  ErrorState({required this.errorMessage});
}
