// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      taskName: json['taskName'] as String,
      todoId: json['todoId'] as String,
      userId: json['userId'] as String,
      isCompleted: json['isCompleted'] as bool,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'taskName': instance.taskName,
      'todoId': instance.todoId,
      'userId': instance.userId,
      'isCompleted': instance.isCompleted,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
