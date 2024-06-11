class Subject {
  final String subjectName;
  final int realAttendance;
  final int attendanceWithProxies;
  final int targetAttendance;

  Subject({
    required this.subjectName,
    required this.realAttendance,
    required this.attendanceWithProxies,
    required this.targetAttendance,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      subjectName: json['subject_name'],
      realAttendance: json['real_attendance'],
      attendanceWithProxies: json['attendance_with_proxies'],
      targetAttendance: json['target_attendance'],
    );
  }
}
