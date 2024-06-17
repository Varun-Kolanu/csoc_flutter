class Subject {
  final String subjectName;
  final String id;
  final int realAttendance;
  final int attendanceWithProxies;
  final int targetAttendance;
  final int credits;
  final List<String> daysHeld;
  final int totalClasses;
  final int attendedClasses;
  final int proxiedClasses;

  Subject({
    required this.subjectName,
    required this.id,
    required this.realAttendance,
    required this.attendanceWithProxies,
    required this.targetAttendance,
    required this.credits,
    required this.daysHeld,
    required this.totalClasses,
    required this.attendedClasses,
    required this.proxiedClasses,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectName: json['subject_name'],
      id: json['id'],
      realAttendance: json['real_attendance'],
      attendanceWithProxies: json['attendance_with_proxies'],
      targetAttendance: json['target_attendance'],
      credits: json['credits'],
      daysHeld: List<String>.from(json['days_held']),
      totalClasses: json['total_classes'],
      attendedClasses: json['attended_classes'],
      proxiedClasses: json['proxied_classes'],
    );
  }
}
