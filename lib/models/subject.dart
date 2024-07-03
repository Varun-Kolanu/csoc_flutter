import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final int targetAttendance;
  final int credits;
  final List<String> daysHeld;
  int totalClasses;
  int attendedClasses;
  int proxiedClasses;
  final String grade;
  final String marks;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Map<DateTime, String> actions;
  Color borderColor = Colors.transparent;
  String userId = '';

  Subject({
    required this.id,
    required this.name,
    required this.targetAttendance,
    required this.credits,
    required this.daysHeld,
    required this.totalClasses,
    required this.attendedClasses,
    required this.proxiedClasses,
    required this.actions,
    this.grade = '',
    this.marks = '',
  });

  Future<void> updateSubject(String userId) async {
    try {
      QuerySnapshot userSnapshot =
          await _db.collection('User').where('id', isEqualTo: userId).get();
      if (userSnapshot.docs.isEmpty) {
        throw Exception('User document not found for ID: $userId');
      }
      DocumentSnapshot userDocument = userSnapshot.docs.first;
      await userDocument.reference
          .collection('subjects')
          .doc(id)
          .update(toJson());
    } catch (e) {
      throw Exception('Error updating subject: $e');
    }
  }

  void updateAction(DateTime date, String action) {
    actions[date] = action;
  }

  String getAction(DateTime date) {
    return actions[date] ?? '';
  }

  int get getClasses {
    if (((attendedClasses - targetAttendance / 100 * totalClasses) /
                (targetAttendance - 1))
            .toInt() <
        1) {
      return 1;
    } else {
      return ((attendedClasses - targetAttendance / 100 * totalClasses) /
              (targetAttendance - 1))
          .toInt();
    }
  }

  int get getProxies {
    if ((((proxiedClasses + attendedClasses) -
                    targetAttendance / 100 * totalClasses) /
                (targetAttendance - 1))
            .toInt() <
        1) {
      return 1;
    } else {
      return (((proxiedClasses + attendedClasses) -
                  targetAttendance / 100 * totalClasses) /
              (targetAttendance - 1))
          .toInt();
    }
  }

  int get bunkClasses {
    return (attendedClasses / targetAttendance * 100 - totalClasses).toInt();
  }

  int get bunkProxies {
    return ((proxiedClasses + attendedClasses) / targetAttendance * 100 -
            totalClasses)
        .toInt();
  }

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
    Map<String, String> actionsMap =
        Map<String, String>.from(json['actions'] ?? {});
    Map<DateTime, String> actions =
        actionsMap.map((key, value) => MapEntry(DateTime.parse(key), value));

    return Subject(
      id: json['id'],
      name: json['name'],
      targetAttendance: json['target_attendance'],
      credits: json['credits'],
      daysHeld: List<String>.from(json['days_held']),
      totalClasses: json['total_classes'],
      attendedClasses: json['classes_attended'],
      proxiedClasses: json['proxied_classes'],
      grade: json['grade'],
      marks: json['marks'],
      actions: actions,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, String> actionsMap =
        actions.map((key, value) => MapEntry(key.toIso8601String(), value));

    return {
      'id': id,
      'name': name,
      'credits': credits,
      'days_held': daysHeld,
      'total_classes': totalClasses,
      'classes_attended': attendedClasses,
      'proxied_classes': proxiedClasses,
      'target_attendance': targetAttendance,
      'grade': grade,
      'marks': marks,
      'actions': actionsMap,
    };
  }

  void attended(DateTime date) {
    if (getAction(date) != 'attended') {
      if (getAction(date).isNotEmpty) undoAction(date);
      attendedClasses++;
      totalClasses++;
      borderColor = Colors.green;
      updateAction(date, 'attended');
      updateSubject(userId);
    }
  }

  void missed(DateTime date) {
    if (getAction(date) != 'missed') {
      if (getAction(date).isNotEmpty) undoAction(date);
      totalClasses++;
      borderColor = Colors.red;
      updateAction(date, 'missed');
      updateSubject(userId);
    }
  }

  void proxied(DateTime date) {
    if (getAction(date) != 'proxied') {
      if (getAction(date).isNotEmpty) undoAction(date);
      proxiedClasses++;
      totalClasses++;
      borderColor = Colors.blue;
      updateAction(date, 'proxied');
      updateSubject(userId);
    }
  }

  void cancelled(DateTime date) {
    if (getAction(date) != 'cancelled') {
      if (getAction(date).isNotEmpty) undoAction(date);
      borderColor = Colors.yellow;
      updateAction(date, 'cancelled');
      updateSubject(userId);
    }
  }

  void undoAction(DateTime date) {
    String action = getAction(date);
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
    actions.remove(date);
  }
}
