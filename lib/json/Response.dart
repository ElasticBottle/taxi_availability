import 'package:json_annotation/json_annotation.dart';

part 'Response.g.dart';

@JsonSerializable()
class CabDetails extends Object {
  @JsonKey(name: "geometry")
  final CabCoordinates cabCoordinates;

  @JsonKey(name: "properties")
  final CabInfo cabInfo;

  CabDetails(this.cabCoordinates, this.cabInfo);

  factory CabDetails.fromJson(Map<String, dynamic> json) =>
      _$CabDetailsFromJson(json);
}

@JsonSerializable()
class CabCoordinates extends Object {
  final List<List<double>> coordinates;

  CabCoordinates(this.coordinates);

  factory CabCoordinates.fromJson(Map<String, dynamic> json) =>
      _$CabCoordinatesFromJson(json);
}

@JsonSerializable()
class CabInfo extends Object {
  final String timestamp;

  @JsonKey(name: "taxi_count")
  final int taxiCount;

  @JsonKey(name: "api_info")
  final ApiStatus status;

  CabInfo(this.timestamp, this.taxiCount, this.status);

  factory CabInfo.fromJson(Map<String, dynamic> json) =>
      _$CabInfoFromJson(json);
}

@JsonSerializable()
class ApiStatus extends Object {
  @JsonKey(name: "status")
  final String health;

  ApiStatus(this.health);

  factory ApiStatus.fromJson(Map<String, dynamic> json) =>
      _$ApiStatusFromJson(json);
}
