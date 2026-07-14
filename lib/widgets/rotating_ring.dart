// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// class RotatingRing extends StatefulWidget {
//   const RotatingRing({super.key});
//
//   @override
//   State<RotatingRing> createState() => _RotatingRingState();
// }
//
// class _RotatingRingState extends State<RotatingRing>
//     with SingleTickerProviderStateMixin {
//
//   late AnimationController controller;
//
//   @override
//   void initState() {
//
//     controller=AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 12),
//     )..repeat();
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return RotationTransition(
//
//       turns: controller,
//
//       child: Container(
//
//         width:180,
//         height:180,
//
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: Colors.green.withOpacity(.3),
//             width:2,
//           ),
//         ),
//
//       ),
//     );
//
//   }
//
//   @override
//   void dispose() {
//
//     controller.dispose();
//
//     super.dispose();
//   }
// }