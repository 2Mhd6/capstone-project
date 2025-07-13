import 'dart:developer';

import 'package:halaqat_wasl_manager_app/model/charity_model/charity_model.dart';
import 'package:halaqat_wasl_manager_app/shared/set_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CharityOperationRepo {

  static final Supabase _charitySupabase = SetupSupabase.sharedSupabase;

  /// [insertingNewCharityIntoDB]  is used when a new charity is signing up with us 
  static Future<void> insertingNewCharityIntoDB({required CharityModel charity}) async {
    try{

      await _charitySupabase.client.from('charity').insert(charity.toMap());

    }catch(error){

      log('Exception - Something went wrong with inserting charity table');
      throw error.toString();

    }
  }

  /// [gettingCharityDataFromDB] is used when a charity wants to log in
  static Future<CharityModel> gettingCharityDataFromDB() async {
    try{

      final userId = _charitySupabase.client.auth.currentUser!.id;

      final charity = await _charitySupabase.client.from('charity').select().eq('charity_id', userId).single();
      
      return CharityModelMapper.fromMap(charity);
    }catch(error){
      
      log('Exception - Something went wrong with getting charity table');
      throw error.toString();
      
    }
  }
}