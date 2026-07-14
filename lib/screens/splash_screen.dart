// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import '../pages/home_page.dart';
//
// import '../widgets/animated_background.dart';
// import '../widgets/orbiting_coins.dart';
// import '../widgets/ripple_animation.dart';
// import '../widgets/rotating_ring.dart';
// import '../widgets/typing_text.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     Timer(
//       const Duration(seconds: 4),
//           () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const HomePage(),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       body: Stack(
//
//         alignment: Alignment.center,
//
//         children: [
//
//           const AnimatedBackground(),
//
//           const RippleAnimation(),
//
//           const RotatingRing(),
//
//           const OrbitingCoins(),
//
//           Column(
//
//             mainAxisAlignment: MainAxisAlignment.center,
//
//             children: [
//
//               Container(
//
//                 width: 110,
//
//                 height: 110,
//
//                 decoration: BoxDecoration(
//                   color: const Color(0xff2E7D32),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.green.withOpacity(.35),
//                       blurRadius: 25,
//                     )
//                   ],
//                 ),
//
//                 child: const Center(
//
//                   child: Text(
//                     "₹",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 52,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 50),
//
//               const TypingText(),
//
//               const SizedBox(height: 12),
//
//               Text(
//                 "Smart Saving • Better Future",
//                 style: TextStyle(
//                   color: Colors.grey.shade700,
//                   fontSize: 15,
//                 ),
//               ),
//
//               const SizedBox(height: 45),
//
//               SizedBox(
//                 width: 180,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(25),
//                   child: const LinearProgressIndicator(
//                     minHeight: 6,
//                   ),
//                 ),
//               ),
//
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }