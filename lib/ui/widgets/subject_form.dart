// subject_form.dart
import 'package:flutter/material.dart';

class SubjectForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Map<String, dynamic>? initialData;

  const SubjectForm({super.key, required this.onSubmit, this.initialData});

  @override
  SubjectFormState createState() => SubjectFormState();
}

class SubjectFormState extends State<SubjectForm> {
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController creditsController = TextEditingController();
  final TextEditingController totalClassesController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      subjectNameController.text = widget.initialData!['name'] ?? '';
      creditsController.text = widget.initialData!['credits']?.toString() ?? '';
      totalClassesController.text =
          widget.initialData!['total_classes']?.toString() ?? '';
      classesAttendedController.text =
          widget.initialData!['classes_attended']?.toString() ?? '';
      proxiedClassesController.text =
          widget.initialData!['proxied_classes']?.toString() ?? '';
      targetAttendanceController.text =
          widget.initialData!['target_attendance']?.toString() ?? '';
      gradeController.text = widget.initialData!['grade'] ?? '';
      marksController.text = widget.initialData!['marks'] ?? '';
      selectedDays = List<String>.from(widget.initialData!['days_held'] ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: subjectNameController,
            decoration: const InputDecoration(
              hintText: 'Subject Name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          TextField(
            controller: creditsController,
            decoration: const InputDecoration(
              hintText: 'Credits',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
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
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          TextField(
            controller: marksController,
            decoration: const InputDecoration(
              hintText: 'Marks',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final Map<String, dynamic> subjectData = {
                'name': subjectNameController.text,
                'credits': int.parse(creditsController.text),
                'days_held': selectedDays,
                'total_classes': int.parse(totalClassesController.text),
                'classes_attended': int.parse(classesAttendedController.text),
                'proxied_classes': int.parse(proxiedClassesController.text),
                'target_attendance': int.parse(targetAttendanceController.text),
                'grade': gradeController.text,
                'marks': marksController.text
              };
              widget.onSubmit(subjectData);
            },
            child: Text(widget.initialData == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }
}
