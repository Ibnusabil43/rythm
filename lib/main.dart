//import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:rythm/firebase_options.dart';
import 'package:rythm/screen/main_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart';
import '../providers/playlistProvider.dart';
import '../providers/songProvider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(
  //options: DefaultFirebaseOptions.currentPlatform,
  //);
  //fillSongList();
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = Duration(seconds: 3)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..indicatorColor = Color(0xFFD2AFFF)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0 // Adjust the size of the loading indicator
    ..radius = 10.0 // Adjust the radius of the loading indicator
    ..maskColor =
        Color(0xFFD2AFFF) // Set the background color of the loading overlay
    ..backgroundColor =
        Color(0xFF1C1C27) // Set the background color of the loading indicator
    ..textColor = Colors.white // Set the text color
    ..textStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
    ..userInteractions = false;
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
        home: main_screen(),
        builder: EasyLoading.init(), // Gantilah Home() dengan widget utama Anda
      ),
    );
  }
}
