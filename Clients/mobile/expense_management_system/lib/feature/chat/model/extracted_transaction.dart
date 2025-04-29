import 'package:freezed_annotation/freezed_annotation.dart';

part 'extracted_transaction.freezed.dart';
part 'extracted_transaction.g.dart';

@freezed
class ExtractedTransaction with _$ExtractedTransaction {
  const factory ExtractedTransaction({
    required int id,
    String? chatExtractionId,
    String? category,
    required int transactionId,
    required String name,
    required double amount,
    required String type,
    required DateTime occurredAt,
    required String confirmationMode,
    required String confirmationStatus,
    required DateTime createdAt,
  }) = _ExtractedTransaction;

  factory ExtractedTransaction.fromJson(Map<String, dynamic> json) =>
      _$ExtractedTransactionFromJson(json);
}
