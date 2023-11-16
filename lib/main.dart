//import 'package:firebase_core/firebase_core.dart';

import 'package:rythm/BottomNavBar/BottomNavigationBar.dart';
import '../screen/songListToAdd.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/material.dart';
import '../screen/home.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../providers/playlistProvider.dart';
import '../providers/songProvider.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(
  //options: DefaultFirebaseOptions.currentPlatform,
  //);
  //fillSongList();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UsersProvider(),
          // Gantilah UserProvider dengan nama kelas Anda
        ),
        ChangeNotifierProvider(
          create: (context) => SongProvider(),
          // Gantilah UserProvider dengan nama kelas Anda
        ),
        ChangeNotifierProvider(create: (context) => PlayListProvider())
      ],
      child: MaterialApp(
        title: 'Rythm',
        theme: ThemeData(fontFamily: 'Poppins'),
        home: BottomNavbar(), // Gantilah Home() dengan widget utama Anda
      ),
    );
  }
}
