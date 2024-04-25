// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      userName: json['userName'] as String,
      imageUrl: json['imageUrl'] as String,
      userId: json['userId'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'imageUrl': instance.imageUrl,
      'userId': instance.userId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
