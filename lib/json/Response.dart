import 'package:json_annotation/json_annotation.dart';

part 'Response.g.dart';

@JsonSerializable()
class BaseResponse extends Object {
  @JsonKey(name: "features")
  final CabDetails cabDetails;

  BaseResponse(this.cabDetails);

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
}

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
  final List<List<int>> coordinates;

  CabCoordinates(this.coordinates);

  factory CabCoordinates.fromJson(Map<String, dynamic> json) =>
      _$CabCoordinatesFromJson(json);
}

@JsonSerializable()
class CabInfo extends Object {
  final String timestamp;

  @JsonKey(name: "taxi_count")
  final String taxiCount;

  @JsonKey(name: "api_info")
  final Status status;

  CabInfo(this.timestamp, this.taxiCount, this.status);

  factory CabInfo.fromJson(Map<String, dynamic> json) =>
      _$CabInfoFromJson(json);
}

@JsonSerializable()
class Status extends Object {
  @JsonKey(name: "status")
  final String health;

  Status(this.health);

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
}
