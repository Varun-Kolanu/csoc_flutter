import 'package:csoc_flutter/cubit/date_cubit.dart';
import 'package:csoc_flutter/models/subject.dart';
import 'package:csoc_flutter/ui/widgets/add_extra_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/theme_cubit.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../widgets/app_bar.dart';
import '../widgets/date_title.dart';
import '../widgets/navigation_drawer.dart';
import 'notifications.dart';

// Can also access current User by AuthService().currentUser globally in the app

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final primaryColor = Theme.of(context).primaryColor;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final secondaryColor = Theme.of(context).colorScheme.secondary;
    // AuthCubit authCubit = context.read<AuthCubit>();
    return Scaffold(
      appBar: CustomAppBar(
        title: DateTitle(),
        textStyle: TextStyle(color: primaryColor),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications()));
              },
              icon: const Icon(Icons.notifications_active_rounded),
              color: primaryColor),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            color: primaryColor,
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0))
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SingleChildScrollView(
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
                                          child:
                                              Text('Error: ${snapshot.error}'));
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
                                              margin:
                                                  const EdgeInsets.symmetric(
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
                                                              color:
                                                                  Colors.green,
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
                                                              color:
                                                                  Colors.blue,
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
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              addextraclass();
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addextraclass() async {
    await showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        scrollable: true,
        title: Text('Add Extra Class'),
        content: SizedBox(
          width: double.maxFinite,
          child: AddExtraClass(),
        ),
      ),
    );
  }
}
