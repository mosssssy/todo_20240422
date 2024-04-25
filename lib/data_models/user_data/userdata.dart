import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'userdata.freezed.dart';
part 'userdata.g.dart';

@freezed
class UserData with _$UserData {
  factory UserData({
    required String userName,
    required String imageUrl,
    required String userId,
    @TimestampConverter() required Timestamp createdAt,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

class TimestampConverter implements JsonConverter<Timestamp, Timestamp> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Timestamp timestamp) {
    return timestamp;
  }

  @override
  Timestamp toJson(Timestamp date) => date;
}
