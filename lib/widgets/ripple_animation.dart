// import 'package:flutter/material.dart';
//
// class RippleAnimation extends StatefulWidget {
//   const RippleAnimation({super.key});
//
//   @override
//   State<RippleAnimation> createState() => _RippleAnimationState();
// }
//
// class _RippleAnimationState extends State<RippleAnimation>
//     with SingleTickerProviderStateMixin {
//
//   late AnimationController controller;
//
//   @override
//   void initState() {
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//
//     super.initState();
//   }
//
//   Widget ripple(double delay){
//
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (_,__){
//
//         double value=(controller.value+delay)%1;
//
//         return Container(
//           width: 140+value*120,
//           height:140+value*120,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Colors.green.withOpacity(.25*(1-value)),
//               width: 2,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//
//         ripple(.0),
//         ripple(.33),
//         ripple(.66),
//
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
// }