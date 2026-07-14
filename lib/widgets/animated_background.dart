// import 'package:flutter/material.dart';
//
// class AnimatedBackground extends StatefulWidget {
//   const AnimatedBackground({super.key});
//
//   @override
//   State<AnimatedBackground> createState() => _AnimatedBackgroundState();
// }
//
// class _AnimatedBackgroundState extends State<AnimatedBackground>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//
//   @override
//   void initState() {
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     )..repeat(reverse: true);
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (_, __) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment(
//                   -1 + controller.value * .5,
//                   -1),
//               end: Alignment(
//                   1,
//                   1 - controller.value * .5),
//               colors: const [
//                 Color(0xffF5FFF6),
//                 Color(0xffECF9EE),
//                 Color(0xffDFF5E4),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }