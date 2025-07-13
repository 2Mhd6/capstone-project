part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class TogglePasswordViabilityEvent extends AuthEvent {}
final class SuccessTogglingPasswordViability extends AuthState {}

final class SignUpEvent extends AuthEvent {}

final class LogInEvent extends AuthEvent {}

final class LoadingState extends AuthState {}

final class SuccessState extends AuthState {
  final String successMessage;
  SuccessState({required this.successMessage});
}

final class ErrorState extends AuthState {
  final String errorMessage;

  ErrorState({required this.errorMessage});
}
