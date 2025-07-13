import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:halaqat_wasl_manager_app/data/supabase_data.dart';
import 'package:halaqat_wasl_manager_app/model/charity_model/charity_model.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:halaqat_wasl_manager_app/model/hospital_model/hospital_model.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/model/user_model/user_model.dart';

class CharityComplaintsRepo {

  static final _charityComplaintsSupabase = GetIt.I.get<SupabaseData>().supabase;

  static Future<List<ComplaintModel>> gettingAllComplaints() async{

    final charityId = _charityComplaintsSupabase.auth.currentUser!.id;

    try{

      // This query will returns all the complaints that assign to a request that has specific charity number
      final complaintsQuery = await _charityComplaintsSupabase.from('complaint').select('*, users(*), requests(*), charity(*), driver(*), hospital(*)').eq('requests.charity_id', charityId);

      // log('$complaintsQuery');

      final allComplaints = complaintsQuery.map((complaint) {
        
        final complaints = complaint['requests'] as List<dynamic>? ?? [];
        final request = complaints.isNotEmpty ? RequestModelMapper.fromMap(complaints.first as Map<String, dynamic>) : null;
        return ComplaintModel(
          complaintId: complaint['complaint_id'],
          userId: complaint['user_id'],
          charityId: complaint['charity_id'],
          requestId: complaint['request_id'],
          driverId: complaint['driver_id'],
          hospitalId: complaint['hospital_id'],
          complaint: complaint['complaint'],
          response: complaint['response'],
          isActive: complaint['is_active'],
          user: complaint['users'] != null ? UserModelMapper.fromMap(complaint['users']) : null,
          charity: complaint['charity'] != null ? CharityModelMapper.fromMap(complaint['charity']) : null,
          driver: complaint['driver'] != null ? DriverModelMapper.fromMap(complaint['driver']) : null,
          hospital: complaint['hospital'] != null ? HospitalModelMapper.fromMap(complaint['hospital']) : null,
          request: request
          );
          }).toList();
          
          return allComplaints;
    }catch(error){
      log(error.toString());
      log('Getting All Complaints - Something went wrong while getting all complaints');
      throw error.toString();
    }
  }

  static Future<ComplaintModel> getComplaintByComplaintId({required String complaintId}) async {
    try{
      
      final complaint = await _charityComplaintsSupabase.from('complaint').select().eq('complaint_id', complaintId);

      return complaint.map((complaint) => ComplaintModelMapper.fromMap(complaint)).toList()[0];

    }catch(error){
      throw error.toString();
    }
  }

  static Future<void> responseToUser({required String response,required String complaintId}) async{
    try{
      await _charityComplaintsSupabase.from('complaint').update(
        {'is_active': false, 'response': response}
      ).eq('complaint_id', complaintId);
    }catch(error){
      throw error.toString();
    }
  }
}