// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class TypingText extends StatefulWidget {
//   const TypingText({super.key});
//
//   @override
//   State<TypingText> createState() => _TypingTextState();
// }
//
// class _TypingTextState extends State<TypingText> {
//   final String text = "PennyPlank";
//
//   String visible = "";
//
//   @override
//   void initState() {
//     super.initState();
//
//     int index = 0;
//
//     Timer.periodic(
//       const Duration(milliseconds: 120),
//           (timer) {
//         if (index >= text.length) {
//           timer.cancel();
//           return;
//         }
//
//         setState(() {
//           visible += text[index];
//           index++;
//         });
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       visible,
//       style: const TextStyle(
//         fontSize: 34,
//         fontWeight: FontWeight.bold,
//         color: Color(0xff2E7D32),
//         letterSpacing: 1.2,
//       ),
//     );
//   }
// }