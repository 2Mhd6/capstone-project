import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/charity_data.dart';
import 'package:halaqat_wasl_manager_app/data/complaint_data.dart';
import 'package:halaqat_wasl_manager_app/data/driver_data.dart';
import 'package:halaqat_wasl_manager_app/data/request_data.dart';
import 'package:halaqat_wasl_manager_app/data/supabase_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SetupSupabase {
  static final Supabase sharedSupabase = Supabase.instance;

  static Future<void> setUpSupabase() {
    return Supabase.initialize(
      url: dotenv.get('supabase_url'),
      anonKey: dotenv.get('supabase_key'),
    );
  }
}

class InjectionContainer {
  static void setUp() {
    // For user data in DB
    GetIt.I.registerSingleton<CharityData>(CharityData());
    GetIt.I.registerSingleton<SupabaseData>(SupabaseData());
    GetIt.I.registerSingleton<RequestData>(RequestData());
    GetIt.I.registerSingleton<ComplaintData>(ComplaintData());
    GetIt.I.registerSingleton<DriverData>(DriverData());
    
  }
}
