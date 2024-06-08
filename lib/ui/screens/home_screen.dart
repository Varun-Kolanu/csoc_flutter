import 'dart:convert';
import 'package:csoc_flutter/cubit/auth_cubit.dart';
import 'package:csoc_flutter/models/user_model.dart';
import 'package:csoc_flutter/ui/widgets/app_bar.dart';
import 'package:csoc_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/attendance.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Subject>> subjects;

  @override
  void initState() {
    super.initState();
    subjects = fetchSubjects();
  }

  Future<List<Subject>> fetchSubjects() async {
    final String response =
    await rootBundle.loadString('assets/attendance_data.json');
    final data = await json.decode(response);
    return (data['subjects'] as List)
        .map((subject) => Subject.fromJson(subject))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.read<AuthCubit>();
    return Scaffold(
      appBar: const CustomAppBar(
        title: "CSOC Flutter",
        backgroundColor: AppColors.primaryColor,
        actions: [],
      ),
      body: Column(
        children: [
          Text(
            widget.user.name!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: authCubit.signOut,
            child: const Text("Sign-out"),
          ),
          const Center(
            child: Column(
              children: [
                Text(
                  'Attendance',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
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
                SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(
            height: 400,
            child: Flexible(
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
                        return Material(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              title: Center(child: Text(subject.subjectName)),
                              tileColor: Colors.cyanAccent,
                              subtitle:Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          
                                  children: [
                                    Text("Real Attendance: ${subject.realAttendance}"),
                                    Text("Proxied Attendance: ${subject.attendanceWithProxies}"),
                                    Text("Target Attendance: ${subject.targetAttendance}"),
                                    const Text("Attend/Can Bunk ------- Clases"),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                          
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.circle, color: Colors.green),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.circle, color: Colors.red),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.circle, color: Colors.blue),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.circle, color: Colors.yellow),
                                        ),//Todo: Add logic in these buttons
                                      ],
                                    ),
                                  ],
                                ),
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
          ),
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
    );
  }
}

