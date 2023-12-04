// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rythm/PopUpWindow/popupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rythm/BottomNavBar/BottomNavigationBar.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showSpinner = false;
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C27),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
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
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        final UserCredential =
                            await _auth.createUserWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );
                        final user = UserCredential.user!.uid;
                        if (user != null) {
                          if (username.text == "") {
                            throw ("UUsername tidak boleh kosong");
                          }
                          CollectionReference collRef =
                              FirebaseFirestore.instance.collection("users");
                          collRef.doc(user).set({
                            'email': email.text,
                            'username': username.text,
                            'songUploaded': [],
                          });
                          final userLog =
                              await _auth.signInWithEmailAndPassword(
                                  email: email.text, password: password.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavbar(),
                            ),
                          );
                          print("Akun berhasil dibuat");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavbar(),
                            ),
                          );
                        } else {
                          print("Gagal membuat akun");
                        }
                      } catch (e) {
                        print("Error: $e");
                        String errorMessage = e.toString();
                        int index = errorMessage.indexOf(']');
                        String finalErrorMessage = errorMessage.substring(
                            index + 2, errorMessage.length);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return popUpWarning(
                              errorMessage: finalErrorMessage,
                              status: "error",
                            );
                          },
                        );
                      } finally {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
        onChanged: (value) {
          setState(() {
            username.text = value;
          });
        },
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
            email.text = value;
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
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Color(0xFFD2AFFF)),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(4),
          hintText: 'Masukkan Password Anda',
          hintStyle: TextStyle(
            color: Color(0xFFD2AFFF).withOpacity(0.5),
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.visibility,
              color: Color(0xFFD2AFFF),
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        obscureText: _obscureText,
        onChanged: (value) {
          setState(() {
            password.text = value;
          });
        },
      ),
    );
  }
}
