import 'package:freezed_annotation/freezed_annotation.dart';

part 'extracted_transaction.freezed.dart';
part 'extracted_transaction.g.dart';

@freezed
class ExtractedTransaction with _$ExtractedTransaction {
  const factory ExtractedTransaction({
    required int chatExtractionId,
    required int chatMessageId,
    String? category,
    required int transactionId,
    required String name,
    required int amount,
    required int type,
    required DateTime occurredAt,
    required int confirmationMode,
    required int confirmationStatus,
    required DateTime createdAt,
  }) = _ExtractedTransaction;

  factory ExtractedTransaction.fromJson(Map<String, dynamic> json) =>
      _$ExtractedTransactionFromJson(json);
}
