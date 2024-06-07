import 'package:csoc_flutter/cubit/auth_cubit.dart';
import 'package:csoc_flutter/models/user_model.dart';
import 'package:csoc_flutter/ui/widgets/app_bar.dart';
import 'package:csoc_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



// Can also access current User by AuthService().currentUser globally in the app

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.read<AuthCubit>();
    return Scaffold(
      appBar: const CustomAppBar(
        title: "CSOC Flutter",
        backgroundColor: AppColors.primaryColor,
        actions: [
        ],

      ),
      body: Column(
        children: [
          Text(widget.user.name!),
          ElevatedButton(
            onPressed: authCubit.signOut,
            child: const Text("Sign-out"),
          ),
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    Icon(Icons.circle, color: Colors.blue),
                    Text('Proxied'),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.circle, color: Colors.yellow),
                    Text('Cancelled'),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(
                height: 200,
                child: SingleChildScrollView(
                    child: Column(
                        children: [
                          //TODO: Add a classes class and display the classes on the selected date here.
                        ]
                    )
                )
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                //TODO: Add logic to add extra class
              },
              child: const Text('Add Extra Class'), ),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: const Text('Back'))
          ],
        ),
      ),
      ],)

      );

  }
}
