// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CabDetails _$CabDetailsFromJson(Map<String, dynamic> json) {
  return CabDetails(
    json['geometry'] == null
        ? null
        : CabCoordinates.fromJson(json['geometry'] as Map<String, dynamic>),
    json['properties'] == null
        ? null
        : CabInfo.fromJson(json['properties'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CabDetailsToJson(CabDetails instance) =>
    <String, dynamic>{
      'geometry': instance.cabCoordinates,
      'properties': instance.cabInfo,
    };

CabCoordinates _$CabCoordinatesFromJson(Map<String, dynamic> json) {
  return CabCoordinates(
    (json['coordinates'] as List)
        ?.map((e) => (e as List)?.map((e) => (e as num)?.toDouble())?.toList())
        ?.toList(),
  );
}

Map<String, dynamic> _$CabCoordinatesToJson(CabCoordinates instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
    };

CabInfo _$CabInfoFromJson(Map<String, dynamic> json) {
  return CabInfo(
    json['timestamp'] as String,
    json['taxi_count'] as int,
    json['api_info'] == null
        ? null
        : ApiStatus.fromJson(json['api_info'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CabInfoToJson(CabInfo instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'taxi_count': instance.taxiCount,
      'api_info': instance.status,
    };

ApiStatus _$ApiStatusFromJson(Map<String, dynamic> json) {
  return ApiStatus(
    json['status'] as String,
  );
}

Map<String, dynamic> _$ApiStatusToJson(ApiStatus instance) => <String, dynamic>{
      'status': instance.health,
    };
