import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/driver_data.dart';
import 'package:halaqat_wasl_manager_app/data/supabase_data.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CharityDriversRepo {
  static final _charityDriversSupabase = GetIt.I.get<SupabaseData>().supabase;

  static final _admin = SupabaseClient(
    dotenv.get('supabase_url'),
    dotenv.get('supabase_server_role_key'),
  );
  
  // Future<void> fillAvailableDrivers({required dateAndTime}) async {
  //   final charityData = GetIt.I.get<CharityData>();

  //   Future.wait(
  //     charityData.drivers.map(
  //       (driver) => _checkAvailability(
  //         driverID: driver.driverId,
  //         dateAndTime: dateAndTime,
  //       ),
  //     ),
  //   );
    
  // }

  // Future<void> _checkAvailability({
  //   required String dateAndTime,
  //   required String driverID,
  // }) async {
  //   final response = await _admin
  //       .from("requests")
  //       .select("*")
  //       .eq("status", "accepted")
  //       .eq("request_date", dateAndTime)
  //       .eq("driver_id", driverID);
  //   if (response.isEmpty) {
  //     final charityData = GetIt.I.get<CharityData>();
  //     for (DriverModel driver in charityData.drivers) {
  //       if (driver.driverId == driverID) {
  //         charityData.drivers.add(driver);
  //       }
  //     }
  //   }
  // }


  

// Future<List<DriverModel>> getAvailableDrivers(DateTime dateAndTime) async {
//     final charityData = GetIt.I.get<CharityData>();
//     final List<DriverModel> availableDrivers = [];

//     await Future.wait(
//       charityData.drivers.map((driver) async {
//         final isAvailable = await _checkAvailability(
//           driverID: driver.driverId,
//           dateAndTime: dateAndTime,
//         );
//         if (isAvailable) {
//           availableDrivers.add(driver);
//         }
//       }),
//     );

//     return availableDrivers;
//   }



//   Future<bool> _checkAvailability({
//     required DateTime dateAndTime,
//     required String driverID,
//   }) async {
//     final response = await _admin
//         .from("requests")
//         .select("*")
//         .eq("status", "accepted")
//         .eq("request_date", dateAndTime)
//         .eq("driver_id", driverID);

//     return response.isEmpty; // true means available
//   }



static Future<List<DriverModel>> getAvailableDrivers(DateTime dateAndTime) async {
    
    final drivers = GetIt.I.get<DriverData>().drivers;
    final List<DriverModel> availableDrivers = [];

    await Future.wait(drivers.map((driver) async {
      final response = await _charityDriversSupabase
          .from("requests")
          .select("*")
          .eq("status", "accepted")
          .eq("request_date", dateAndTime)
          .eq("driver_id", driver.driverId);

          log('---${response}');

      final isAvailable = response.isEmpty;
      if (isAvailable) {
        availableDrivers.add(driver);
      }
    }));

    return availableDrivers;
  }


  static Future<List<DriverModel>> gettingAllDrivers() async {
    //

    final charityId = _charityDriversSupabase.auth.currentUser!.id;

    try {
      final driverQuery = await _charityDriversSupabase
          .from('driver')
          .select('*,charity(*)')
          .eq('charity_id', charityId);
          

      final drivers = driverQuery
          .map((e) => DriverModelMapper.fromMap(e))
          .toList();

      return drivers;
    } catch (error) {
      log(
        'Getting All Drivers - Something went wrong while getting all Drivers',
      );
      throw error.toString();
    }
  }

  static Future<DriverModel> getDriverByDriverId({required String driverId}) async {
    try{

      final driver =  await _charityDriversSupabase.from('driver').select().eq('driver_id', driverId);

      log('Getting driver by driver id - Everting goes as we wanted');

      return driver.map((driver) => DriverModelMapper.fromMap(driver)).toList()[0];

    }catch(error){

      log('Getting driver by driver id - Something went wrong while getting request by driver id');
      throw error.toString();

    }
  }

  static Future<UserResponse> registerNewDriver({
    required String email,
    required String phoneNumber,
  }) async {
    try {
      log(phoneNumber);
      return await _admin.auth.admin.createUser(
        AdminUserAttributes(email: email, password: '+966$phoneNumber', emailConfirm: true),
      );
    } on AuthException catch (error) {
      log(
        'AuthException - Register new driver -- Something went wrong while registering a new driver',
      );
      throw error.message;
    } catch (error) {
      log(
        'General Exception - Register new driver -- Something went wrong while registering a new driver',
      );
      throw error.toString();
    }
  }

  static Future<void> insertingNewDriverIntoDB({
    required DriverModel driver,
  }) async {
    try {
      // -- Why I am doing this to insert the driver manually instead of using driver to map?
      // -- Because  inside driver model there is a nested charity model that used only for reading not for inserting
      // -- So, to avoid errors you need to inserting them manually
      await _charityDriversSupabase.from('driver').insert({
        'driver_id': driver.driverId,
        'charity_id': driver.charityId,
        'notification_id': driver.notificationId,
        'full_name': driver.fullName,
        'role': driver.role,
        'status': driver.status,
        'phone_number': driver.phoneNumber,
        'total_services': driver.totalServices,
      });
    } catch (error) {
      log(
        'Inserting driver into DB -- Something went wrong while inserting a new driver to DB',
      );
      throw error.toString();
    }
  }
}
