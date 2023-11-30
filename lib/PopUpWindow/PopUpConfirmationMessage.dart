import 'package:flutter/material.dart';

class ConfirmationPopup extends StatelessWidget {
  final String confirmationMessage;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationPopup({
    Key? key,
    required this.confirmationMessage,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      backgroundColor: Color(0xFF313142),
      contentPadding: EdgeInsets.all(5),
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              size: 100,
              color: Color(0xFFD2AFFF),
            ),
            SizedBox(height: 10),
            Text(
              confirmationMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFD2AFFF),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD2AFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ).copyWith(
                    fixedSize: MaterialStateProperty.all(
                      Size(100,
                          20), // Ganti dengan lebar dan tinggi yang diinginkan
                    ),
                  ),
                  child: Text(
                    'Tidak',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD2AFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ).copyWith(
                    fixedSize: MaterialStateProperty.all(
                      Size(100,
                          20), // Ganti dengan lebar dan tinggi yang diinginkan
                    ),
                  ),
                  child: Text(
                    'Ya',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
