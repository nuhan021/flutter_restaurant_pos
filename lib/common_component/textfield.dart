import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final Icon myIcon;
  final void Function()? myFun;
  const MyTextField({
    super.key,
    required this.hintText,
    required this.myIcon,
    this.myFun,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.varelaRound(fontSize: 15),
        enabled: true,
        filled: true,
        suffixIcon: GestureDetector(
          onTap: myFun,
            child: myIcon),
        fillColor: Colors.grey[600],
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.transparent, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.deepOrange, width: 1)),
      ),
    );
  }
}
