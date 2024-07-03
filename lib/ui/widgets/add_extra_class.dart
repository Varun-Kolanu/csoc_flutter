import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/date_cubit.dart';
import '../../models/subject.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';

class AddExtraClass extends StatefulWidget {
  const AddExtraClass({super.key});

  @override
  State<AddExtraClass> createState() => _AddExtraClassState();
}

class _AddExtraClassState extends State<AddExtraClass> {
  late Future<List<Subject>> subjects;
  final userCredentials = AuthService().currentUser!;
  final FirestoreService _firestoreService = FirestoreService();

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
  void initState() {
    super.initState();
    subjects = fetchSubjects();
    context.read<DateCubit>().resetDate();
  }

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(userCredentials.displayName ?? 'User'),
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
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No subjects available'));
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
                                              border: Border.all(
                                                  color: subject.borderColor,
                                                  width: 2.0),
                                              color: secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: ListTile(
                                              hoverColor: Colors.purpleAccent,
                                              title: Center(
                                                  child: Text(subject.name)),
                                              subtitle: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                    Text(subject.targetAttendance >
                                                            subject
                                                                .realAttendance
                                                        ? "You Have To Attend ${subject.getClasses} Classes"
                                                        : "You Can Bunk ${subject.bunkClasses} Classes"),
                                                    Text(subject.targetAttendance >
                                                            subject
                                                                .proxiedAttendance
                                                        ? "Get ${subject.getProxies} Proxies"
                                                        : "You Can Leave ${subject.bunkProxies} Proxies"),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              final currentAction =
                                                                  subject.getAction(
                                                                      selectedDate);
                                                              if (currentAction !=
                                                                  'attended') {
                                                                if (currentAction
                                                                    .isNotEmpty) {
                                                                  subject.undoAction(
                                                                      selectedDate);
                                                                }
                                                                subject.attended(
                                                                    selectedDate);
                                                                subject.updateSubject(
                                                                    userCredentials
                                                                        .uid);
                                                              }
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.circle,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              final currentAction =
                                                                  subject.getAction(
                                                                      selectedDate);
                                                              if (currentAction !=
                                                                  'missed') {
                                                                if (currentAction
                                                                    .isNotEmpty) {
                                                                  subject.undoAction(
                                                                      selectedDate);
                                                                }
                                                                subject.missed(
                                                                    selectedDate);
                                                                subject.updateSubject(
                                                                    userCredentials
                                                                        .uid);
                                                              }
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.circle,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              final currentAction =
                                                                  subject.getAction(
                                                                      selectedDate);
                                                              if (currentAction !=
                                                                  'proxied') {
                                                                if (currentAction
                                                                    .isNotEmpty) {
                                                                  subject.undoAction(
                                                                      selectedDate);
                                                                }
                                                                subject.proxied(
                                                                    selectedDate);
                                                                subject.updateSubject(
                                                                    userCredentials
                                                                        .uid);
                                                              }
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.circle,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              final currentAction =
                                                                  subject.getAction(
                                                                      selectedDate);
                                                              if (currentAction !=
                                                                  'cancelled') {
                                                                if (currentAction
                                                                    .isNotEmpty) {
                                                                  subject.undoAction(
                                                                      selectedDate);
                                                                }
                                                                subject.cancelled(
                                                                    selectedDate);
                                                                subject.updateSubject(
                                                                    userCredentials
                                                                        .uid);
                                                              }
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.circle,
                                                            color:
                                                                Colors.yellow,
                                                          ),
                                                        ),
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
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
