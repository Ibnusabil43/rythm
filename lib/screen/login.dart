import 'package:firebase_auth/firebase_auth.dart';
import 'package:rythm/BottomNavBar/BottomNavigationBar.dart';
import 'package:rythm/providers/songProvider.dart';
import 'package:rythm/screen/HomeScree.dart';
import 'package:rythm/screen/popupScreen.dart';
import '../screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _loginstate();
}

class _loginstate extends State<LogIn> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final password = TextEditingController();
  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C27),
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 19, right: 19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFFD2AFFF),
                    size: 37,
                  ),
                ),
                Text(
                  'Masuk',
                  style: TextStyle(
                    color: Color(0xFFD2AFFF),
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            SizedBox(
              height: 95,
            ),
            Text(
              'Email',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            formEmail(),
            SizedBox(
              height: 39,
            ),
            Text(
              'Password',
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            formPassword(),
            SizedBox(
              height: 53,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 86,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavbar()),
                        );
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                      String finalErrorMessage = "Email atau Password Salah";
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return popUpWarning(
                            errorMessage: finalErrorMessage,
                            status: "error",
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Center(
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    width: 86,
                    height: 49,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD2AFFF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget formNama() {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF313142),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            hintText: 'Masukkan Nama Anda',
            hintStyle: TextStyle(
              color: Color(0xFFD2AFFF).withOpacity(0.5),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget formEmail() {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF313142),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        onChanged: (value) {
          email.text = value.trim();
        },
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            hintText: 'Masukkan Email Anda',
            hintStyle: TextStyle(
              color: Color(0xFFD2AFFF).withOpacity(0.5),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget formPassword() {
    return Container(
      decoration: ShapeDecoration(
        color: Color(0xFF313142),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        onChanged: (value) {
          password.text = value.trim();
        },
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(4),
            hintText: 'Masukkan Password Anda',
            hintStyle: TextStyle(
              color: Color(0xFFD2AFFF).withOpacity(0.5),
            ),
            border: InputBorder.none),
        obscureText: true,
      ),
    );
  }
}
