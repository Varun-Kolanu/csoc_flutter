import 'package:csoc_flutter/cubit/date_cubit.dart';
import 'package:csoc_flutter/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/theme_cubit.dart';
import '../../models/subject.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../widgets/date_title.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late Future<List<Subject>> subjects;
  final FirestoreService _firestoreService = FirestoreService();

  final userCredentials = AuthService().currentUser!;

  final day = DateTime.now().weekday;
  final date = DateTime.now().toString();
  @override
  void initState() {
    super.initState();
    subjects = fetchSubjects();
    context.read<DateCubit>().resetDate();
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
        appBar: CustomAppBar(
          title: DateTitle(),
          textStyle: TextStyle(color: primaryColor),
          backgroundColor: backgroundColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              color: primaryColor,
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(userCredentials.displayName!),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Attendance',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.circle, color: Colors.green),
                            Text('Present'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.circle, color: Colors.red),
                            Text('Absent'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.circle, color: Colors.yellow),
                            Text('Cancelled'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.circle, color: Colors.blue),
                            Text('Proxied'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: 400, // Constrains the ListView's height
                        child: BlocBuilder<DateCubit, DateTime>(
                            builder: (context, selectedDate) {
                          final selectedWeekday =
                              DateFormat('EEEE').format(selectedDate);
                          return FutureBuilder<List<Subject>>(
                            future: subjects,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                final subjects = snapshot.data!
                                    .where((subject) => subject.daysHeld
                                        .contains(selectedWeekday))
                                    .toList();
                                return Material(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: subjects.length,
                                    itemBuilder: (context, index) {
                                      final subject = subjects[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: ListTile(
                                          title:
                                              Center(child: Text(subject.name)),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "Real Attendance: ${subject.realAttendance}"),
                                                Text(
                                                    "Proxied Attendance: ${subject.proxiedAttendance}"),
                                                Text(
                                                    "Target Attendance: ${subject.targetAttendance}"),
                                                const Text(
                                                    "Attend/Can Bunk ------- Classes"),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.circle,
                                                          color: Colors.green),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.circle,
                                                          color: Colors.red),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.circle,
                                                          color: Colors.blue),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.circle,
                                                          color: Colors.yellow),
                                                    ), //TODO: Add logic in these buttons
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          );
                        })),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Add logic to add extra class
                      },
                      child: const Text('Add Extra Class'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
