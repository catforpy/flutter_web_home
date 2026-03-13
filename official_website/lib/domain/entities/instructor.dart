import 'package:flutter/material.dart';

/// 讲师实体
class Instructor {
  final String id;
  final String name;
  final String avatar;
  final String bio;
  final List<String> subjects;
  final DateTime registerTime;
  final InstructorStatus status;
  final CooperationMode cooperationMode;
  final int studentCount;
  final int followerCount;
  final double averageRating;

  const Instructor({
    required this.id,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.subjects,
    required this.registerTime,
    required this.status,
    required this.cooperationMode,
    required this.studentCount,
    required this.followerCount,
    required this.averageRating,
  });

  Instructor copyWith({
    String? id,
    String? name,
    String? avatar,
    String? bio,
    List<String>? subjects,
    DateTime? registerTime,
    InstructorStatus? status,
    CooperationMode? cooperationMode,
    int? studentCount,
    int? followerCount,
    double? averageRating,
  }) {
    return Instructor(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      subjects: subjects ?? this.subjects,
      registerTime: registerTime ?? this.registerTime,
      status: status ?? this.status,
      cooperationMode: cooperationMode ?? this.cooperationMode,
      studentCount: studentCount ?? this.studentCount,
      followerCount: followerCount ?? this.followerCount,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}

/// 讲师状态
enum InstructorStatus {
  online('在线', Colors.green),
  busy('忙碌', Colors.orange),
  offline('离线', Colors.grey);

  final String displayName;
  final Color color;

  const InstructorStatus(this.displayName, this.color);
}

/// 合作模式
enum CooperationMode {
  partner('合伙人'),
  lease('租赁');

  final String displayName;

  const CooperationMode(this.displayName);
}
