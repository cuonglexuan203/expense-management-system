// import 'package:flutter/material.dart';
// import 'package:expense_management_system/app/widget/bottom_nav_bar.dart';
// import 'package:expense_management_system/gen/colors.gen.dart';
// import 'package:go_router/go_router.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:expense_management_system/feature/wallet/widget/add_transaction_page.dart';

// class WalletPage extends StatefulWidget {
//   const WalletPage({super.key});

//   @override
//   State<WalletPage> createState() => _WalletPageState();
// }

// class _WalletPageState extends State<WalletPage> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SafeArea(
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color(0xFFB7C5E1),
//                 Color(0xFF4B7BF9),
//               ],
//             ),
//           ),
//           child: Column(
//             children: [
//               // Header
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => context.go('/'),
//                     ),
//                     const Text(
//                       'Wallet',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         fontFamily: 'Nunito',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Text(
//                           'Total Balance',
//                           style: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 16,
//                             fontFamily: 'Nunito',
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           '\$2,548.00',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Nunito',
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             _buildActionButton(
//                               icon: Iconsax.arrow_up_1,
//                               label: 'Add Expense',
//                               onTap: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       const AddTransactionPage(isExpense: true),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             _buildActionButton(
//                               icon: Iconsax.arrow_down_2,
//                               label: 'Add Income',
//                               onTap: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       const AddTransactionPage(
//                                           isExpense: false),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         // Tabs
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 15),
//                                   decoration: BoxDecoration(
//                                     color: ColorName.blue,
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                   child: const Center(
//                                     child: Text(
//                                       'Transactions',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                         fontFamily: 'Nunito',
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 // Transactions List
//                                 _buildTransactionItem(
//                                   icon: 'assets/upwork.png',
//                                   title: 'Upwork',
//                                   date: 'Today',
//                                   amount: '+\$850.00',
//                                   isIncome: true,
//                                 ),
//                                 _buildTransactionItem(
//                                   icon: 'assets/transfer.png',
//                                   title: 'Transfer',
//                                   date: 'Yesterday',
//                                   amount: '-\$85.00',
//                                   isIncome: false,
//                                 ),
//                                 _buildTransactionItem(
//                                   icon: 'assets/paypal.png',
//                                   title: 'Paypal',
//                                   date: 'Jan 30, 2022',
//                                   amount: '+\$1,406.00',
//                                   isIncome: true,
//                                 ),
//                                 _buildTransactionItem(
//                                   icon: 'assets/youtube.png',
//                                   title: 'Youtube',
//                                   date: 'Jan 16, 2022',
//                                   amount: '-\$11.99',
//                                   isIncome: false,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => context.push('/chat'),
//         shape: const CircleBorder(),
//         backgroundColor: const Color(0xFF386BF6),
//         child: const Icon(Iconsax.add, color: Colors.white),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               color: ColorName.blue,
//               size: 36,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               color: ColorName.black,
//               fontSize: 12,
//               fontFamily: 'Nunito',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTransactionItem({
//     required String icon,
//     required String title,
//     required String date,
//     required String amount,
//     required bool isIncome,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Image.asset(icon),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: 'Nunito',
//                   ),
//                 ),
//                 Text(
//                   date,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                     fontFamily: 'Nunito',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             amount,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: isIncome ? Colors.green : Colors.red,
//               fontFamily: 'Nunito',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
