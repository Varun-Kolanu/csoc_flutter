// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../models/subject.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../widgets/app_bar.dart';
import '../widgets/subject_form.dart';

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
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subject'),
        content: SubjectForm(
          onSubmit: (subjectData) async {
            await _firestoreService.addSubject(
                userCredentials.uid, subjectData);
            setState(() {
              subjects = fetchSubjects(); // Refresh the list
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _editSubject(Subject subject) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Subject'),
        content: SubjectForm(
          initialData: subject.toJson(),
          onSubmit: (subjectData) async {
            await _firestoreService.updateSubject(
                userCredentials.uid, subject.id, subjectData);
            setState(() {
              subjects = fetchSubjects(); // Refresh the list
            });
            Navigator.of(context).pop();
          },
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
                                      "Real Attendance: ${subject.realAttendance.toStringAsFixed(2)}%",
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                    Text(
                                      "Proxied Attendance: ${subject.proxiedAttendance.toStringAsFixed(2)}%",
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    Text(
                                      "Target Attendance: ${subject.targetAttendance}%",
                                      style:
                                          const TextStyle(color: Colors.purple),
                                    ),
                                    Text(
                                      "Schedule: ${subject.daysHeld.join(', ')}",
                                      style:
                                          const TextStyle(color: Colors.brown),
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
                                                color: Colors.black54)),
                                        const SizedBox(width: 10),
                                        Text("Marks: ${subject.marks}",
                                            style: const TextStyle(
                                                color: Colors.black54)),
                                      ],
                                    ),
                                    // TODO: Add the logic to calculate the number of days to attend/can bunk
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editSubject(subject),
                                  padding: const EdgeInsets.all(10),
                                ),
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
