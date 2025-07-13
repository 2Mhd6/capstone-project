import 'dart:developer';
import 'package:halaqat_wasl_manager_app/shared/set_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepo {
  static final Supabase _supabaseAuth = SetupSupabase.sharedSupabase;

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabaseAuth.client.auth.signUp(
        email: email,
        password: password,
      );
    } on AuthException catch (error) {
      log(
        'AuthRepo -- Sign up -- Something went wrong in AuthException catch block',
      );
      throw error.message;
    } catch (error) {
      log('AuthRepo -- Sign up -- Something went wrong in general catch block');
      throw error.toString();
    }
  }

  static Future<AuthResponse> logIn({
    required String email,
    required String password,
  }) async {
    
    try {
      final user = await _supabaseAuth.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return user;
    } on AuthException catch (error) {
      log(
        'AuthRepo -- Log in -- Something went wrong in AuthException catch block',
      );
      throw error.message;
    } catch (error) {
      log('AuthRepo -- Log in -- Something went wrong in general catch block');
      throw error.toString();
    }
  }

  static Future<void> logOut() async {
    await _supabaseAuth.client.auth.signOut();
  }

  static Future<User> gettingCharity() async {
    return _supabaseAuth.client.auth.currentSession!.user;
  }
}
