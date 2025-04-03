import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/chat/model/extracted_transaction.dart';
import 'package:expense_management_system/feature/chat/model/media.dart';
import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final Function(int, String)? onConfirmTransaction;

  const MessageBubble({
    super.key,
    required this.message,
    this.onConfirmTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.role.toLowerCase() == "user";

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUserMessage ? ColorName.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(15).copyWith(
            bottomRight: isUserMessage ? const Radius.circular(0) : null,
            bottomLeft: !isUserMessage ? const Radius.circular(0) : null,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.content.isNotEmpty)
                Text(
                  message.content,
                  style: TextStyle(
                    color: isUserMessage ? Colors.white : Colors.black87,
                    fontFamily: 'Nunito',
                  ),
                ),
              if (message.medias.isNotEmpty) _buildMediaContent(context),
              const SizedBox(height: 4),
              Text(
                DateFormat('HH:mm').format(message.createdAt),
                style: TextStyle(
                  color: isUserMessage
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black54,
                  fontSize: 10,
                ),
                textAlign: isUserMessage ? TextAlign.right : TextAlign.left,
              ),
              if (message.extractedTransactions.isNotEmpty)
                _buildExtractedTransactions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    if (message.medias.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ...message.medias.map((media) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                onTap: () => _showFullScreenImage(context, media),
                child: Hero(
                  tag: media.id,
                  child: CachedNetworkImage(
                    imageUrl: media.secureUrl,
                    placeholder: (context, url) => Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorName.blue,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, Media media) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: Hero(
              tag: media.id,
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(media.secureUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtractedTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.black26),
        ...message.extractedTransactions
            .map((transaction) => _buildTransactionCard(context, transaction))
            .toList(),
      ],
    );
  }

  Widget _buildTransactionCard(
      BuildContext context, ExtractedTransaction transaction) {
    String typeText = transaction.type == 'Expense' ? 'Expense' : 'Income';
    Color typeColor = typeText == 'Expense' ? Colors.red : Colors.green;

    final confirmedStatusNotifier =
        ValueNotifier<String>(transaction.confirmationStatus);

    return ValueListenableBuilder<String>(
        valueListenable: confirmedStatusNotifier,
        builder: (context, confirmedStatus, _) {
          bool isPending = confirmedStatus == 'Pending';

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: _getStatusColor(confirmedStatus).withOpacity(0.3),
                width: 1,
              ),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Nunito',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          typeText,
                          style: TextStyle(
                            color: typeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(builder: (context, constraints) {
                    bool useVerticalLayout = constraints.maxWidth < 250;

                    Widget amountWidget = Text(
                      transaction.amount.toFormattedString(),
                      style: TextStyle(
                        color: typeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    );

                    Widget buttonsWidget = !isPending
                        ? _buildStatusChip(confirmedStatus)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildActionButton(
                                'Confirm',
                                Colors.white,
                                ColorName.blue,
                                () => _handleConfirmAction(
                                  context,
                                  transaction.id,
                                  'Confirmed',
                                  confirmedStatusNotifier,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildActionButton(
                                'Reject',
                                Colors.white,
                                Colors.red,
                                () => _handleConfirmAction(
                                  context,
                                  transaction.id,
                                  'Rejected',
                                  confirmedStatusNotifier,
                                ),
                              ),
                            ],
                          );

                    if (useVerticalLayout) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          amountWidget,
                          const SizedBox(height: 8),
                          Center(child: buttonsWidget),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          amountWidget,
                          buttonsWidget,
                        ],
                      );
                    }
                  }),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _handleConfirmAction(
    BuildContext context,
    int transactionId,
    String status,
    ValueNotifier<String> statusNotifier,
  ) async {
    try {
      statusNotifier.value = status;

      if (onConfirmTransaction != null) {
        await onConfirmTransaction!(transactionId, status);

        AppSnackBar.showSuccess(
          context: context,
          message: status == 'Confirmed'
              ? 'Transaction confirmed'
              : 'Transaction rejected',
        );
      }
    } catch (e) {
      statusNotifier.value = 'Pending';

      AppSnackBar.showError(
        context: context,
        message: 'Failed to process transaction. Please try again.',
        actionLabel: 'Retry',
        onActionPressed: () => _handleConfirmAction(
            context, transactionId, status, statusNotifier),
      );
    }
  }

  // Tạo nút hành động với màu được chỉ định
  Widget _buildActionButton(
    String label,
    Color textColor,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 34, // Giảm chiều cao
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12), // Giảm padding
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 13, // Giảm cỡ chữ
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Hiển thị chip trạng thái
  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }

  // Xác định màu cho từng trạng thái
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
