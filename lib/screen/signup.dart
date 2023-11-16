import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rythm/screen/popupScreen.dart';
import '../screen/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

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
                  'Daftar',
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
              'Nama',
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
            formNama(),
            SizedBox(
              height: 39,
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
                      await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      showSpinner = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                home()), // Assuming you have a Home widget.
                      );
                    } catch (e) {
                      // Handle errors here, e.g., show a snackbar with an error message.
                      print("Error: $e");
                      String error = e.toString();
                      int index = error.indexOf(']');
                      String errorMessages =
                          error.substring(index + 2, error.length);
                      showSpinner =
                          false; // Ensure spinner is turned off in case of an error.
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return popUpWarning(
                                errorMessage: errorMessages, status: "error");
                          });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    width: 86,
                    height: 49,
                    decoration: ShapeDecoration(
                      color: Color(0xFFD2AFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Daftar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
          border: InputBorder.none,
        ),
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
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          hintText: 'Masukkan Email Anda',
          hintStyle: TextStyle(
            color: Color(0xFFD2AFFF).withOpacity(0.5),
          ),
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            email = value;
          });
        },
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
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          hintText: 'Masukkan Password Anda',
          hintStyle: TextStyle(
            color: Color(0xFFD2AFFF).withOpacity(0.5),
          ),
          border: InputBorder.none,
        ),
        obscureText: true,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
      ),
    );
  }
}
