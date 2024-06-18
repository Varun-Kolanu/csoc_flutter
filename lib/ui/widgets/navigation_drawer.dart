import 'package:csoc_flutter/ui/screens/friend_timetable.dart';
import 'package:csoc_flutter/ui/screens/friends.dart';
import 'package:csoc_flutter/ui/screens/grades.dart';
import 'package:csoc_flutter/ui/screens/proxy.dart';
import 'package:csoc_flutter/ui/screens/settings.dart';
import 'package:csoc_flutter/ui/screens/user_timetable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth_cubit.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.read<AuthCubit>();
    final userCredentials = AuthService().currentUser;
    // userCredentials.isAnonymous
    Map<String, dynamic> userMap = {
      "name": "Name",
      "email": "Email Address",
      "uid": "User id"
    };
    if (userCredentials != null) {
      userMap = UserModel(
              email: userCredentials.email,
              id: userCredentials.uid,
              name: userCredentials.displayName)
          .toJson();
    }
    String imgurl =
        "https://images.unsplash.com/photo-1495615080073-6b89c9839ce0?q=80&w=2048&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  CircleAvatar(
                    // Use CircleAvatar for profile picture
                    radius: 40.0, // Adjust radius for desired size
                    backgroundImage: NetworkImage(imgurl),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0), // Adjust padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userMap["name"].length > 17
                              ? userMap["name"].substring(0, 17) + "..."
                              : userMap["name"],
                          style: const TextStyle(
                            fontSize: 18.0, // Set font size
                            fontWeight: FontWeight.bold, // Bold username
                          ),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                        Text(
                          userMap["email"].length > 17
                              ? userMap["email"].substring(0, 17) + "..."
                              : userMap["email"],
                          style: const TextStyle(
                            fontSize: 16.0, // Set font size
                          ),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                        const Text(
                          "Branch",
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.w500), // Optional: slightly bolder
                        ),
                        const Text(
                            "Roll Number"), // No other style changes needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.subject),
              title: const Text('Subjects'),
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const HomeScreen()));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grade),
              title: const Text('Grades'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GradeScreen(userId: userMap["id"])));
              },
            ),
            ListTile(
              leading: const Icon(Icons.connect_without_contact),
              title: const Text('Friends'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FriendsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.developer_board),
              title: const Text('My TimeTable'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserTimetable()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.developer_board),
              title: const Text('Friends\' TimeTable'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FriendTimetable()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_task),
              title: const Text('Request proxy'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProxyPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Settings()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: authCubit.signOut,
            ),
          ],
        ),
      ),
    );
  }
}
