// import 'dart:math';
// import 'package:flutter/material.dart';
//
// class OrbitingCoins extends StatefulWidget {
//   const OrbitingCoins({super.key});
//
//   @override
//   State<OrbitingCoins> createState() => _OrbitingCoinsState();
// }
//
// class _OrbitingCoinsState extends State<OrbitingCoins>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 8),
//     )..repeat();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 260,
//       height: 260,
//       child: AnimatedBuilder(
//         animation: controller,
//         builder: (_, __) {
//           return Stack(
//             alignment: Alignment.center,
//             children: List.generate(6, (i) {
//               double angle =
//                   controller.value * 2 * pi + (i * pi / 3);
//
//               double radius = 95;
//
//               return Transform.translate(
//                 offset: Offset(
//                   cos(angle) * radius,
//                   sin(angle) * radius,
//                 ),
//                 child: Container(
//                   width: 34,
//                   height: 34,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xffFFD54F),
//                         Color(0xffF9A825),
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.amber.withOpacity(.45),
//                         blurRadius: 12,
//                       ),
//                     ],
//                   ),
//                   child: const Center(
//                     child: Text(
//                       "₹",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }