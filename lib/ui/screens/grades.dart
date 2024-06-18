import 'package:csoc_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';

class GradeScreen extends StatelessWidget {
  final String userId;

  const GradeScreen({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    FirestoreService firestoreService = FirestoreService();
    return firestoreService.fetchSubjects(userId);
  }

  double calculateSPI(List<Map<String, dynamic>> subjects) {
    final gradePoints = {
      'A': 10.0,
      'A-': 9.0,
      'B+': 8.0,
      'B': 7.0,
      'C': 6.0,
      'D': 5.0,
      'F': 0.0,
    };

    double totalCredits = 0;
    double totalPoints = 0;
    for (var subject in subjects) {
      int credits = subject['credits'];
      String grade = subject['grade'];
      double gradeValue = gradePoints[grade] ??
          0.0; // Get the corresponding grade value from the map
      totalCredits += credits;
      totalPoints += credits * gradeValue;
    }
    return totalPoints / totalCredits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final subjects = snapshot.data!;
            final spi = calculateSPI(subjects);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('SPI: ${spi.toStringAsFixed(2)}'),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        return Card(
                          child: ListTile(
                            title: Text(subject['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Marks: ${subject['marks']}'),
                                Text('Expected Grade: ${subject['grade']}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // TODO: handle edit button
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No subjects found'));
        },
      ),
    );
  }
}
