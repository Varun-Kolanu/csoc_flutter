// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../widgets/app_bar.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({
    super.key,
  }); // will receive this from the home screen when the button is clicked in the sidebar.

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late Future<List<Subject>> subjects;
  final FirestoreService _firestoreService = FirestoreService();
  final userCredentials = AuthService().currentUser!;

  @override
  void initState() {
    super.initState();
    subjects = fetchSubjects();
  }

  Future<List<Subject>> fetchSubjects() async {
    try {
      final List<Map<String, dynamic>> subjectData =
          await _firestoreService.fetchSubjects(userCredentials.uid);
      if (subjectData.isEmpty) {
        return [];
      }
      return subjectData.map((data) => Subject.fromJson(data)).toList();
    } catch (e) {
      throw Exception('Error fetching subjects: $e');
    }
  }

  Future<void> _addSubject() async {
    final TextEditingController subjectNameController = TextEditingController();
    final TextEditingController creditsController = TextEditingController();
    final TextEditingController totalClassesController =
        TextEditingController();
    final TextEditingController classesAttendedController =
        TextEditingController();
    final TextEditingController proxiedClassesController =
        TextEditingController();
    final TextEditingController targetAttendanceController =
        TextEditingController();
    final TextEditingController gradeController = TextEditingController();
    final TextEditingController marksController = TextEditingController();

    List<String> selectedDays = [];

    final Map<String, String> dayMap = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
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
                Wrap(
                  spacing: 8.0,
                  children: dayMap.entries.map((entry) {
                    return ChoiceChip(
                      label: Text(entry.key),
                      selected: selectedDays.contains(entry.value),
                      selectedColor: Colors.blue,
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? selectedDays.add(entry.value)
                              : selectedDays.remove(entry.value);
                        });
                      },
                    );
                  }).toList(),
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
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(
                      hintText: 'Expected Grade',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                TextField(
                  controller: marksController,
                  decoration: const InputDecoration(
                      hintText: 'Marks',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
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
                final String name = subjectNameController.text;
                final String grade = gradeController.text;
                final String marks = marksController.text;
                final int credits = int.parse(creditsController.text);
                final List<String> daysHeld = selectedDays;
                final int targetAttendance =
                    int.parse(targetAttendanceController.text);
                final int totalClasses = int.parse(totalClassesController.text);
                final int classesAttended =
                    int.parse(classesAttendedController.text);
                final int proxiedClasses =
                    int.parse(proxiedClassesController.text);

                final Map<String, dynamic> subjectData = {
                  'name': name,
                  'credits': credits,
                  'days_held': daysHeld,
                  'total_classes': totalClasses,
                  'classes_attended': classesAttended,
                  'proxied_classes': proxiedClasses,
                  'target_attendance': targetAttendance,
                  'grade': grade,
                  'marks': marks
                };

                await _firestoreService.addSubject(
                    userCredentials.uid, subjectData);
                setState(() {
                  subjects = fetchSubjects(); // Refresh the list
                });

                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
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
                                    child: Text(subject.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Real Attendance: ${subject.realAttendance.toString()}",
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                    Text(
                                      "Proxied Attendance: ${subject.proxiedAttendance.toString()}",
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    Text(
                                      "Target Attendance: ${subject.targetAttendance.toString()}",
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
                                    Row(
                                      children: [
                                        Text("Grade: ${subject.grade}",
                                            style: const TextStyle(
                                                color: Colors.white10)),
                                        Text("Marks: ${subject.marks}",
                                            style: const TextStyle(
                                                color: Colors.white10)),
                                      ],
                                    ),

                                    const Text(
                                      "Attend/Can Bunk ------- Classes",
                                      style: TextStyle(color: Colors.black),
                                    ), //TODO: Add the logic to calculate the number of days in place of ----.
                                  ],
                                ),
                                trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {},
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
