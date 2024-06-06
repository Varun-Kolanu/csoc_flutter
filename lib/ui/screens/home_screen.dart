import 'package:csoc_flutter/cubit/auth_cubit.dart';
import 'package:csoc_flutter/models/user_model.dart';
import 'package:csoc_flutter/ui/widgets/app_bar.dart';
import 'package:csoc_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'attendance.dart';

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
      appBar:   const CustomAppBar(
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
        ],
      ),
      bottomNavigationBar:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              IconButton(onPressed: ()=> {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Attendance()))
              }, icon: const Icon(Icons.menu_book_rounded) ),
              const Text('Attendance')
            ],
          ),
          Column(
            children: [
              IconButton(onPressed:()=>{} //Todo: Add the reminder page.
                  , icon: const Icon(Icons.book))
            ],
          )
        ],

      ),
    );
  }
}
