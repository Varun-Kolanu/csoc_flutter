import 'package:csoc_flutter/cubit/auth_cubit.dart';
import 'package:csoc_flutter/firebase_options.dart';
import 'package:csoc_flutter/repositories/user_repository.dart';
import 'package:csoc_flutter/ui/screens/home_screen.dart';
import 'package:csoc_flutter/ui/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csoc_flutter/ui/screens/grades.dart'; // Import the new grade screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing the firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // BLOC Pattern:
  // 1. We call cubit, cubit does some work and calls repository.
  // 2. Repository is responsible for returning data from APIs.
  // 3. Repository uses Models to convert data into JSON format or JSON to class.
  // 4. Then after all data returning, cubit emits a state. According to that state, UI gets changed inside BlocProvider.

  // Creating the AuthCubit for state management. This provides cubit to all its children.
  runApp(
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(UserRepository()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return MaterialApp(
      home: BlocBuilder<AuthCubit, AuthState>(
        bloc: authCubit,
        builder: (context, state) {
          if (state is AuthInitial) {
            return const LoginScreen();
          } else if (state is AuthSuccess) {
            return HomeScreen(user: state.user);
          } else if (state is AuthError) {
            return LoginScreen(
              msg: state.error,
            );
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
