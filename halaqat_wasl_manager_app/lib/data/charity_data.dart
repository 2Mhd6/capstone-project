import 'package:halaqat_wasl_manager_app/model/charity_model/charity_model.dart';
import 'package:halaqat_wasl_manager_app/model/complaint_model/complaint_model.dart';
import 'package:halaqat_wasl_manager_app/model/driver_model/driver_model.dart';
import 'package:halaqat_wasl_manager_app/model/request_model/request_model.dart';

class CharityData {

  // Charity
  late CharityModel charity;

  List<RequestModel> requestHistory = [];
  List<ComplaintModel> complaintsHistory = [];
}