import 'package:csoc_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/auth_cubit.dart';

class SideNavigationBar extends StatelessWidget {
  final String? accountName;
  final String? accountEmail;
  const SideNavigationBar(
      {super.key, required this.accountName, required this.accountEmail});

  @override
  Widget build(BuildContext context) {
    final String username =
        "${accountName!.split(" ")[0]} ${accountName!.split(" ")[1]}";

    AuthCubit authCubit = context.read<AuthCubit>();
    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.secondaryColor),
              accountName: Text(username,
                  style: TextStyle(
                      color: Colors.indigo.shade900,
                      fontWeight: FontWeight.bold)),
              accountEmail: Text(accountEmail!,
                  style: TextStyle(color: Colors.indigo.shade900)),
              currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                      child: Image.network(
                "https://i.pinimg.com/564x/fd/14/a4/fd14a484f8e558209f0c2a94bc36b855.jpg",
                fit: BoxFit.fill,
                width: 90,
                height: 90,
              )))),
          ListTile(
            leading: const Icon(Icons.my_library_books_outlined),
            title: const Text('Subjects'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.star_purple500_outlined),
            title: const Text('Grades'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.my_library_books_outlined),
            title: const Text('Subjects'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Time Table'),
            onTap: () {},
          ),
          Divider(
            indent: 100,
            endIndent: 100,
            color: Colors.grey.shade500,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authCubit.signOut();
            },
          )
        ],
      ),
    );
  }
}
