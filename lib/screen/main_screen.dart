import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rythm/BottomNavBar/BottomNavigationBar.dart';
import 'package:rythm/providers/userProvider.dart';
import 'package:rythm/screen/welcome.dart';

class main_screen extends StatelessWidget {
  const main_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              context.read<UsersProvider>().setid(snapshot.data!.uid);
              context.read<UsersProvider>().fetchprofile();
              return BottomNavbar();
            } else {
              return welcome();
            }
          }),
    );
  }
}
