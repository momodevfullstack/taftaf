import 'package:flutter/material.dart';


// models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String avatar;
  final double distance;
  final List<String> skills;
  final List<String> needs;
  final double rating;
  final int exchanges;
  final bool isOnline;
  final DateTime lastSeen;
  final String? profileImage;
  final String level;
  final String responseTime;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.distance,
    required this.skills,
    required this.needs,
    required this.rating,
    required this.exchanges,
    required this.isOnline,
    required this.lastSeen,
    this.profileImage,
    required this.level,
    required this.responseTime,
  });
}

class StatModel {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  StatModel(this.title, this.value, this.icon, this.color, this.subtitle);
}