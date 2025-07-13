import 'dart:async';
import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/supabase_data.dart';
import 'package:halaqat_wasl_manager_app/model/charity_model/charity_model.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:halaqat_wasl_manager_app/model/hospital_model/hospital_model.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/model/user_model/user_model.dart';

class RequestsRepo {
  static final _requestSupabase = GetIt.I.get<SupabaseData>().supabase;

    static Future<List<RequestModel>> gettingAllRequests() async {
    try {
      final requestQuery = await _requestSupabase
          .from('requests')
          .select('*, users(*), charity(*), driver(*), hospital(*), complaint(*)')
          .order('request_date', ascending: true);

      final allRequests = requestQuery.map((request) {
        return RequestModel(
          requestId: request['request_id'],
          userId: request['user_id'],
          charityId: request['charity_id'],
          hospitalId: request['hospital_id'],
          complaintId: request['complaint_id'],
          driverId: request['driver_id'],
          pickupLat: request['pick_up_lat'],
          pickupLong: request['pick_up_long'],
          pickUpReadableAddress: request['pick_up_readable_address'],
          destinationLat: request['destination_lat'],
          destinationLong: request['destination_long'],
          destinationReadableAddress: request['destination_readable_address'],
          requestDate: DateTime.parse(request['request_date']),
          status: request['status'],
          note: request['note'],
          user: request['users'] != null
              ? UserModelMapper.fromMap(request['users'])
              : null,
          charity: request['charity'] != null
              ? CharityModelMapper.fromMap(request['charity'])
              : null,
          driver: request['driver'] != null
              ? DriverModelMapper.fromMap(request['driver'])
              : null,
          hospital: request['hospital'] != null
              ? HospitalModelMapper.fromMap(request['hospital'])
              : null,
          complaint: request['complaint'] != null
              ? ComplaintModelMapper.fromMap(request['complaint'])
              : null,
        );
      }).toList();

      log('Success Getting All Requests');

      return allRequests;

    } catch (error) {
      log(
        'General Exception - Something went wrong when we trying to get the requests',
      );
      throw error.toString();
    }
  }

  static Future<List<RequestModel>> gettingAllPendingRequests() async {
    try {
      final requestQuery = await _requestSupabase
          .from('requests')
          .select(
            '*, users(*), charity(*), driver(*), hospital(*), complaint(*)',
          )
          .eq('status', 'pending')
          .order('request_date',ascending: true);

      final allPendingRequests = requestQuery.map((request) {
        
        return RequestModel(
          requestId: request['request_id'],
          userId: request['user_id'],
          charityId: request['charity_id'],
          hospitalId: request['hospital_id'],
          complaintId: request['complaint_id'],
          driverId: request['driver_id'],
          pickupLat: request['pick_up_lat'],
          pickupLong: request['pick_up_long'],
          pickUpReadableAddress: request['pick_up_readable_address'],
          destinationLat: request['destination_lat'],
          destinationLong: request['destination_long'],
          destinationReadableAddress: request['destination_readable_address'],
          requestDate: DateTime.parse(request['request_date']),
          status: request['status'],
          note: request['note'],
          user: request['users'] != null
              ? UserModelMapper.fromMap(request['users'])
              : null,
          charity: request['charity'] != null
              ? CharityModelMapper.fromMap(request['charity'])
              : null,
          driver: request['driver'] != null
              ? DriverModelMapper.fromMap(request['driver'])
              : null,
          hospital: request['hospital'] != null
              ? HospitalModelMapper.fromMap(request['hospital'])
              : null,
          complaint: request['complaint'] != null
              ? ComplaintModelMapper.fromMap(request['complaint'])
              : null,
        );
      }).toList();

      log('Success Getting All pending Requests');

      return allPendingRequests;
    } catch (error) {
      log(
        'General Exception - Something went wrong when we trying to get the pending requests',
      );
      throw error.toString();
    }
  }

  static Future<RequestModel> getRequestByRequestId({
    required String requestId,
  }) async {
    try {
      final request = await _requestSupabase
          .from('requests')
          .select()
          .eq('request_id', requestId);

      log('Getting request by request id - Everting goes as we wanted');

      return request
          .map((request) => RequestModelMapper.fromMap(request))
          .toList()[0];
    } catch (error) {
      log(
        'Getting request by request id - Something went wrong while getting request by request id',
      );
      throw error.toString();
    }
  }


  static Future<void> assigningRequestToDriver({required RequestModel request,required String driverId,}) async {
    try {
      await _requestSupabase
          .from('requests')
          .update({
            'driver_id': driverId,
            'status': 'accepted',
            'charity_id': _requestSupabase.auth.currentUser!.id,
          })
          .eq('request_id', request.requestId);

      log('Success Assigning Driver To a request ${request.requestId}');
    } catch (error) {
      log(
        'General Exception -- Something went wrong while assign a request to a driver',
      );
      throw error.toString();
    }
  }
}



