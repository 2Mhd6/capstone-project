// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_mappable/dart_mappable.dart';
import 'package:halaqat_wasl_manager_app/model/charity_model/charity_model.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:halaqat_wasl_manager_app/model/hospital_model/hospital_model.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';
import 'package:halaqat_wasl_manager_app/model/user_model/user_model.dart';

part 'complaint_model.mapper.dart';

@MappableClass()
class ComplaintModel with ComplaintModelMappable {
  ComplaintModel({
    required this.complaintId,
    required this.userId,
    required this.charityId,
    required this.requestId,
    required this.driverId,
    required this.hospitalId,
    required this.complaint,
    required this.response,
    required this.isActive,

  
    this.user,
    this.charity,
    this.request,
    this.driver,
    this.hospital,
  });

  @MappableField(key: 'complaint_id')
  final String complaintId;

  @MappableField(key: 'request_id')
  final String? requestId;

  @MappableField(key: 'user_id')
  final String? userId;

  @MappableField(key: 'charity_id')
  final String? charityId;

  @MappableField(key: 'driver_id')
  final String? driverId;

  @MappableField(key: 'hospital_id')
  final String? hospitalId;

  final String complaint;
  final String response;

  @MappableField(key: 'is_active')
  final bool isActive;

  // Nested models for join support
  final UserModel? user;
  final CharityModel? charity;
  final RequestModel? request;
  final DriverModel? driver;
  final HospitalModel? hospital;
}
