// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'driver_model.dart';

class DriverModelMapper extends ClassMapperBase<DriverModel> {
  DriverModelMapper._();

  static DriverModelMapper? _instance;
  static DriverModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DriverModelMapper._());
      CharityModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DriverModel';

  static String _$driverId(DriverModel v) => v.driverId;
  static const Field<DriverModel, String> _f$driverId =
      Field('driverId', _$driverId, key: r'driver_id');
  static String _$charityId(DriverModel v) => v.charityId;
  static const Field<DriverModel, String> _f$charityId =
      Field('charityId', _$charityId, key: r'charity_id');
  static String? _$notificationId(DriverModel v) => v.notificationId;
  static const Field<DriverModel, String> _f$notificationId =
      Field('notificationId', _$notificationId, key: r'notification_id');
  static String _$fullName(DriverModel v) => v.fullName;
  static const Field<DriverModel, String> _f$fullName =
      Field('fullName', _$fullName, key: r'full_name');
  static String _$role(DriverModel v) => v.role;
  static const Field<DriverModel, String> _f$role = Field('role', _$role);
  static String _$status(DriverModel v) => v.status;
  static const Field<DriverModel, String> _f$status = Field('status', _$status);
  static int _$totalServices(DriverModel v) => v.totalServices;
  static const Field<DriverModel, int> _f$totalServices =
      Field('totalServices', _$totalServices, key: r'total_services');
  static String _$phoneNumber(DriverModel v) => v.phoneNumber;
  static const Field<DriverModel, String> _f$phoneNumber =
      Field('phoneNumber', _$phoneNumber, key: r'phone_number');
  static CharityModel? _$charity(DriverModel v) => v.charity;
  static const Field<DriverModel, CharityModel> _f$charity =
      Field('charity', _$charity, opt: true);

  @override
  final MappableFields<DriverModel> fields = const {
    #driverId: _f$driverId,
    #charityId: _f$charityId,
    #notificationId: _f$notificationId,
    #fullName: _f$fullName,
    #role: _f$role,
    #status: _f$status,
    #totalServices: _f$totalServices,
    #phoneNumber: _f$phoneNumber,
    #charity: _f$charity,
  };

  static DriverModel _instantiate(DecodingData data) {
    return DriverModel(
        driverId: data.dec(_f$driverId),
        charityId: data.dec(_f$charityId),
        notificationId: data.dec(_f$notificationId),
        fullName: data.dec(_f$fullName),
        role: data.dec(_f$role),
        status: data.dec(_f$status),
        totalServices: data.dec(_f$totalServices),
        phoneNumber: data.dec(_f$phoneNumber),
        charity: data.dec(_f$charity));
  }

  @override
  final Function instantiate = _instantiate;

  static DriverModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DriverModel>(map);
  }

  static DriverModel fromJson(String json) {
    return ensureInitialized().decodeJson<DriverModel>(json);
  }
}

mixin DriverModelMappable {
  String toJson() {
    return DriverModelMapper.ensureInitialized()
        .encodeJson<DriverModel>(this as DriverModel);
  }

  Map<String, dynamic> toMap() {
    return DriverModelMapper.ensureInitialized()
        .encodeMap<DriverModel>(this as DriverModel);
  }

  DriverModelCopyWith<DriverModel, DriverModel, DriverModel> get copyWith =>
      _DriverModelCopyWithImpl<DriverModel, DriverModel>(
          this as DriverModel, $identity, $identity);
  @override
  String toString() {
    return DriverModelMapper.ensureInitialized()
        .stringifyValue(this as DriverModel);
  }

  @override
  bool operator ==(Object other) {
    return DriverModelMapper.ensureInitialized()
        .equalsValue(this as DriverModel, other);
  }

  @override
  int get hashCode {
    return DriverModelMapper.ensureInitialized().hashValue(this as DriverModel);
  }
}

extension DriverModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DriverModel, $Out> {
  DriverModelCopyWith<$R, DriverModel, $Out> get $asDriverModel =>
      $base.as((v, t, t2) => _DriverModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DriverModelCopyWith<$R, $In extends DriverModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CharityModelCopyWith<$R, CharityModel, CharityModel>? get charity;
  $R call(
      {String? driverId,
      String? charityId,
      String? notificationId,
      String? fullName,
      String? role,
      String? status,
      int? totalServices,
      String? phoneNumber,
      CharityModel? charity});
  DriverModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DriverModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DriverModel, $Out>
    implements DriverModelCopyWith<$R, DriverModel, $Out> {
  _DriverModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DriverModel> $mapper =
      DriverModelMapper.ensureInitialized();
  @override
  CharityModelCopyWith<$R, CharityModel, CharityModel>? get charity =>
      $value.charity?.copyWith.$chain((v) => call(charity: v));
  @override
  $R call(
          {String? driverId,
          String? charityId,
          Object? notificationId = $none,
          String? fullName,
          String? role,
          String? status,
          int? totalServices,
          String? phoneNumber,
          Object? charity = $none}) =>
      $apply(FieldCopyWithData({
        if (driverId != null) #driverId: driverId,
        if (charityId != null) #charityId: charityId,
        if (notificationId != $none) #notificationId: notificationId,
        if (fullName != null) #fullName: fullName,
        if (role != null) #role: role,
        if (status != null) #status: status,
        if (totalServices != null) #totalServices: totalServices,
        if (phoneNumber != null) #phoneNumber: phoneNumber,
        if (charity != $none) #charity: charity
      }));
  @override
  DriverModel $make(CopyWithData data) => DriverModel(
      driverId: data.get(#driverId, or: $value.driverId),
      charityId: data.get(#charityId, or: $value.charityId),
      notificationId: data.get(#notificationId, or: $value.notificationId),
      fullName: data.get(#fullName, or: $value.fullName),
      role: data.get(#role, or: $value.role),
      status: data.get(#status, or: $value.status),
      totalServices: data.get(#totalServices, or: $value.totalServices),
      phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
      charity: data.get(#charity, or: $value.charity));

  @override
  DriverModelCopyWith<$R2, DriverModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DriverModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
