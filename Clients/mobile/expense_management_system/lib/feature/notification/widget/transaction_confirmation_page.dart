// // lib/feature/extracted_transaction/widget/transaction_confirmation_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// import '../model/extracted_transaction.dart';
// import '../../notification/repository/notification_repository.dart';

// // Provider to fetch the extracted transaction
// final extractedTransactionProvider = FutureProvider.family<ExtractedTransaction?, int>(
//   (ref, id) async {
//     // In a real app, this would call an API to get the transaction
//     // For this example, we'll use a mock
//     await Future.delayed(Duration(milliseconds: 500));
    
//     // Mock data
//     return ExtractedTransaction(
//       id: id,
//       chatExtractionId: 1,
//       transactionId: 0, // 0 means not yet confirmed
//       name: "Coffee at Starbucks",
   
