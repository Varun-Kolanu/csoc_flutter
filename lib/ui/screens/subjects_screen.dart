import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import '../widgets/app_bar.dart';

class SubjectsPage extends StatefulWidget {
  final UserModel user;
  const SubjectsPage(
      {super.key,
      required this.user}); // will receive this from the home screen when the button is clicked in the sidebar.

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late Future<List<Subject>> subjects;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    subjects = fetchSubjects();
  }

  Future<List<Subject>> fetchSubjects() async {
    try {
      final List<Map<String, dynamic>> subjectData =
          await _firestoreService.fetchSubjects(widget.user.id.toString());
      if (subjectData.isEmpty) {
        return [];
      }
      return subjectData.map((data) => Subject.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Error fetching subjects: $e');
    }
  }

  Future<void> _addSubject() async {
    // Basically, a function to add subjects to the firebase database.
    final TextEditingController subjectNameController = TextEditingController();
    final TextEditingController creditsController = TextEditingController();
    final TextEditingController daysHeldController = TextEditingController();
    final TextEditingController totalClassesController =
        TextEditingController();
    final TextEditingController classesAttendedController =
        TextEditingController();
    final TextEditingController proxiedClassesController =
        TextEditingController();
    final TextEditingController targetAttendanceController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subject'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: subjectNameController,
                decoration: const InputDecoration(
                    hintText: 'Subject Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              TextField(
                controller: creditsController,
                decoration: const InputDecoration(
                    hintText: 'Credits',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: daysHeldController,
                decoration: const InputDecoration(
                  hintText: 'Days Held (comma separated)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              TextField(
                controller: totalClassesController,
                decoration: const InputDecoration(
                  hintText: 'Total Classes Till Now',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: classesAttendedController,
                decoration: const InputDecoration(
                  hintText: 'Classes Attended',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: proxiedClassesController,
                decoration: const InputDecoration(
                  hintText: 'Proxied Classes',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: targetAttendanceController,
                decoration: const InputDecoration(
                  hintText: 'Target Attendance',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final String subjectName = subjectNameController.text;
              final int credits = int.parse(creditsController.text);
              final List<String> daysHeld = daysHeldController.text
                  .split(',')
                  .map((day) => day.trim())
                  .toList();
              final int targetAttendance =
                  int.parse(targetAttendanceController.text);
              final int totalClasses = int.parse(totalClassesController.text);
              final int classesAttended =
                  int.parse(classesAttendedController.text);
              final int proxiedClasses =
                  int.parse(proxiedClassesController.text);

              final Map<String, dynamic> subjectData = {
                'subject_name': subjectName,
                'credits': credits,
                'days_held': daysHeld,
                'total_classes': totalClasses,
                'classes_attended': classesAttended,
                'proxied_classes': proxiedClasses,
                'target_attendance': targetAttendance,
              };

              await _firestoreService.addSubject(
                  widget.user.id.toString(), subjectData);
              setState(() {
                subjects = fetchSubjects(); // Refresh the list
              });

              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _editSubject(Subject subject) async {
    // Basically, a function to edit and existing subject.
    final TextEditingController subjectNameController =
        TextEditingController(text: subject.subjectName);
    final TextEditingController creditsController =
        TextEditingController(text: subject.credits.toString());
    final TextEditingController daysHeldController =
        TextEditingController(text: subject.daysHeld.join(', '));
    final TextEditingController totalClassesController =
        TextEditingController(text: subject.totalClasses.toString());
    final TextEditingController classesAttendedController =
        TextEditingController(text: subject.attendedClasses.toString());
    final TextEditingController proxiedClassesController =
        TextEditingController(text: subject.proxiedClasses.toString());
    final TextEditingController targetAttendanceController =
        TextEditingController(text: subject.targetAttendance.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Subject'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: subjectNameController,
                decoration: const InputDecoration(labelText: 'Subject Name'),
              ),
              TextField(
                controller: creditsController,
                decoration: const InputDecoration(labelText: 'Credits'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: daysHeldController,
                decoration: const InputDecoration(
                    labelText: 'Days Held (comma separated)'),
              ),
              TextField(
                controller: totalClassesController,
                decoration:
                    const InputDecoration(labelText: 'Total Classes Till Now'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: classesAttendedController,
                decoration:
                    const InputDecoration(labelText: 'Classes Attended'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: proxiedClassesController,
                decoration: const InputDecoration(labelText: 'Proxied Classes'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: targetAttendanceController,
                decoration:
                    const InputDecoration(labelText: 'Target Attendance'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final String subjectName = subjectNameController.text;
              final int credits = int.parse(creditsController.text);
              final List<String> daysHeld = daysHeldController.text
                  .split(',')
                  .map((day) => day.trim())
                  .toList();
              final int totalClasses = int.parse(totalClassesController.text);
              final int classesAttended =
                  int.parse(classesAttendedController.text);
              final int proxiedClasses =
                  int.parse(proxiedClassesController.text);
              final int targetAttendance =
                  int.parse(targetAttendanceController.text);

              final Map<String, dynamic> updatedSubjectData = {
                'subject_name': subjectName,
                'credits': credits,
                'days_held': daysHeld,
                'total_classes': totalClasses,
                'classes_attended': classesAttended,
                'proxied_classes': proxiedClasses,
                'target_attendance': targetAttendance,
              };

              try {
                // Update subject data in Firestore
                await _firestoreService.editSubject(
                    subject.id, updatedSubjectData);
                setState(() {
                  subjects = fetchSubjects(); // Refresh the list
                });
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error editing subject: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("Subjects"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: const [],
        textStyle: TextStyle(color: Theme.of(context).primaryColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Subject>>(
                  future: subjects,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final subjects = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                focusColor: Colors.blueGrey,
                                title: Center(
                                    child: Text(subject.subjectName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Real Attendance: ${subject.realAttendance}",
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                    Text(
                                      "Proxied Attendance: ${subject.attendanceWithProxies}",
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    Text(
                                      "Target Attendance: ${subject.targetAttendance}",
                                      style:
                                          const TextStyle(color: Colors.purple),
                                    ),
                                    Text(
                                      "Schedule: ${subject.daysHeld.join(', ')}",
                                      style:
                                          const TextStyle(color: Colors.brown),
                                    ),
                                    Text(
                                      "Days Held: ${subject.daysHeld.join(', ')}\n",
                                      style: const TextStyle(
                                          color: Colors.white10),
                                    ),
                                    Text(
                                      "Credits: ${subject.credits}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),

                                    const Text(
                                      "Attend/Can Bunk ------- Classes",
                                      style: TextStyle(color: Colors.black),
                                    ), //TODO: Add the logic to calculate the number of days in place of ----.
                                  ],
                                ),
                                trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _editSubject(subject);
                                    },
                                    padding: const EdgeInsets.all(10)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              TextButton(
                  onPressed: _addSubject, child: const Text("Add Subject")),
            ],
          ),
        ),
      ),
    );
  }
}
