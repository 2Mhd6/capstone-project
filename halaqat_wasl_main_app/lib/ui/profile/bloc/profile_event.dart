part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

// Event to request loading the profile data.
class ProfileDataLoadRequested extends ProfileEvent{}  

// Event to sign out the user.
class ProfileSignOutRequested extends ProfileEvent{}