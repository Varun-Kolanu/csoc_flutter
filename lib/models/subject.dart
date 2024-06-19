import 'package:flutter/material.dart';

class Subject {
  final String name;
  final int targetAttendance;
  final int credits;
  final List<String> daysHeld;
  int totalClasses;
  int attendedClasses;
  int proxiedClasses;
  final String grade = "";
  final String marks = "";
  String selectedAction;

  Subject({
    required this.name,
    required this.targetAttendance,
    required this.credits,
    required this.daysHeld,
    required this.totalClasses,
    required this.attendedClasses,
    required this.proxiedClasses,
    this.selectedAction = '',
  });

  double get realAttendance {
    if (totalClasses == 0) return 0.0;
    return double.parse(
        ((attendedClasses / totalClasses) * 100).toStringAsFixed(2));
  }

  double get proxiedAttendance {
    if (totalClasses == 0) return 0.0;
    return double.parse(
        (((attendedClasses + proxiedClasses) / totalClasses) * 100)
            .toStringAsFixed(2));
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      targetAttendance: json['target_attendance'],
      credits: json['credits'],
      daysHeld: List<String>.from(json['days_held']),
      totalClasses: json['total_classes'],
      attendedClasses: json['classes_attended'],
      proxiedClasses: json['proxied_classes'],
    );
  }
  Color borderColor = Colors.transparent;
  void attended() {
    attendedClasses++;
    totalClasses++;
    borderColor = Colors.green;
  }

  void missed() {
    totalClasses++;
    borderColor = Colors.red;
  }

  void proxied() {
    proxiedClasses++;
    totalClasses++;
    borderColor = Colors.blue;
  }

  void cancelled() {
    borderColor = Colors.yellow;
  }

  void undoAction(String action) {
    switch (action) {
      case 'attended':
        attendedClasses--;
        totalClasses--;
        break;
      case 'missed':
        totalClasses--;
        break;
      case 'proxied':
        proxiedClasses--;
        totalClasses--;
        break;
      case 'cancelled':
        // No change needed for cancelled
        break;
    }
  }
}
