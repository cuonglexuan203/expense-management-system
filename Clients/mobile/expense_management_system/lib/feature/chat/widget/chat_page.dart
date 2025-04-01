import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/auth/repository/token_repository.dart';
import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/feature/chat/provider/chat_provider.dart';
import 'package:expense_management_system/feature/chat/repository/chat_repository.dart';
import 'package:expense_management_system/feature/chat/widget/message_bubble.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends ConsumerStatefulWidget {
  final int walletId;

  const ChatPage({super.key, required this.walletId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool isAddTransaction = true;
  int? chatThreadId;
  bool isLoading = true;
  bool isWaitingForResponse = false;

  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingImage = false;
  List<XFile>? _selectedImages;

  Future<void> _pickImage() async {
    try {
      final List<XFile>? images = await _imagePicker.pickMultiImage();

      if (images == null || images.isEmpty) return;

      setState(() {
        _selectedImages = images;
      });
    } catch (e) {
      AppSnackBar.showError(
        context: context,
        message: 'Can not select image: ${e.toString()}',
      );
    }
  }

  void _clearSelectedImages() {
    setState(() {
      _selectedImages = null;
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    final hasImages = _selectedImages != null && _selectedImages!.isNotEmpty;

    if (message.isEmpty && !hasImages) {
      return;
    }

    if (chatThreadId == null || isWaitingForResponse || _isUploadingImage) {
      return;
    }

    _messageController.clear();

    setState(() {
      isWaitingForResponse = true;
    });

    try {
      // Step 1: Send message via WebSocket first
      final receivedMessage =
          await ref.read(chatRepositoryProvider).sendMessageViaWebSocket(
                widget.walletId,
                chatThreadId!,
                message,
              );

      // Step 2: Now we have the message with ID from WebSocket
      if (hasImages && receivedMessage != null) {
        setState(() {
          _isUploadingImage = true;
        });

        // Set upload processing flag
        ref.read(chatRepositoryProvider).setUploadProcessingStatus(true);

        try {
          final uploadedMedia =
              await ref.read(chatRepositoryProvider).uploadMediaToMessage(
                    messageId: receivedMessage.id,
                    walletId: widget.walletId,
                    files: _selectedImages!,
                  );

          final updatedMessage = receivedMessage.copyWith(
            medias: uploadedMedia,
          );
          ref.read(chatProvider.notifier).addReceivedMessage(updatedMessage);
        } finally {
          // Reset both flags
          ref.read(chatRepositoryProvider).setUploadProcessingStatus(false);

          setState(() {
            _selectedImages = null;
            _isUploadingImage = false;
            isWaitingForResponse =
                false; // Only reset here after upload completes
          });
        }
      }
    } catch (e) {
      AppSnackBar.showError(
        context: context,
        message: 'Failed to send message: ${e.toString()}',
      );
    } finally {
      // QUAN TRỌNG: Luôn reset trạng thái đợi, bất kể thành công hay thất bại
      setState(() {
        isWaitingForResponse = false;
        _isUploadingImage = false;
      });
    }
  }

  // Future<Message?> _findUserMessageByContent(String content) async {
  //   final messagesState = ref.read(chatProvider);
  //   final messages = messagesState.maybeWhen(
  //     loaded: (msgs) => msgs,
  //     orElse: () => <Message>[],
  //   );

  //   for (var msg in messages) {
  //     if (msg.role.toLowerCase() == 'user' && msg.content == content) {
  //       return msg;
  //     }
  //   }

  //   await ref.read(chatProvider.notifier).fetchMessages(chatThreadId!);

  //   final refreshedMessagesState = ref.read(chatProvider);
  //   final refreshedMessages = refreshedMessagesState.maybeWhen(
  //     loaded: (msgs) => msgs,
  //     orElse: () => <Message>[],
  //   );

  //   for (var msg in refreshedMessages) {
  //     if (msg.role.toLowerCase() == 'user' && msg.content == content) {
  //       return msg;
  //     }
  //   }

  //   return null;
  // }

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    ref.read(chatRepositoryProvider).disconnect();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 10 &&
        !isLoading) {
      _loadMoreMessages();
    }
  }

  Future<void> _loadMoreMessages() async {
    if (chatThreadId == null) return;

    await ref.read(chatProvider.notifier).loadMoreMessages(chatThreadId!);
  }

  Future<void> _initializeChat() async {
    try {
      setState(() {
        isLoading = true;
      });

      final chatThreads =
          await ref.read(chatRepositoryProvider).getChatThreads();

      print('Chat-threads: $chatThreads');

      if (isAddTransaction) {
        final financeThread = chatThreads.firstWhere(
          (thread) => thread['title'] == 'Finance',
          orElse: () => {'id': null},
        );
        chatThreadId =
            financeThread['id'] != null ? financeThread['id'] as int : null;
        print('chatThreadId: $chatThreadId');
      } else {
        final assistantThread = chatThreads.firstWhere(
          (thread) => thread['title'] == 'Assistant',
          orElse: () => {'id': null},
        );
        chatThreadId =
            assistantThread['id'] != null ? assistantThread['id'] as int : null;
      }

      if (chatThreadId != null) {
        await ref.read(chatProvider.notifier).fetchMessages(chatThreadId!);

        final tokenRepository = ref.read(tokenRepositoryProvider);
        final accessToken = await tokenRepository.getAccessToken();
        print('Acesss token: $accessToken');
        if (accessToken != null) {
          await ref.read(chatRepositoryProvider).connect(accessToken);

          ref.read(chatRepositoryProvider).setOnMessageReceivedCallback(() {
            // Only handle system messages or reset for non-upload scenarios
            if (!_isUploadingImage) {
              setState(() {
                isWaitingForResponse = false;
              });
            }
            _scrollToBottom();
          });
        } else {
          throw AppException.errorWithMessage("Do not have Access Token");
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    } catch (e) {
      debugPrint('Error initializing chat: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _changeTab(bool isAddTransactionTab) async {
    if (isAddTransaction == isAddTransactionTab) return;

    setState(() {
      isAddTransaction = isAddTransactionTab;
      isLoading = true;
    });

    await _initializeChat();
  }

  // Future<void> _sendMessage() async {
  //   if (_messageController.text.isEmpty ||
  //       chatThreadId == null ||
  //       isWaitingForResponse) return;

  //   final message = _messageController.text;
  //   _messageController.clear();

  //   final userMessage = Message(
  //     id: DateTime.now().millisecondsSinceEpoch,
  //     chatThreadId: chatThreadId!,
  //     userId: 'current_user',
  //     role: 'User',
  //     content: message,
  //     createdAt: DateTime.now(),
  //     extractedTransactions: [],
  //   );

  //   ref.read(chatProvider.notifier).addReceivedMessage(userMessage);

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _scrollToBottom();
  //   });

  //   setState(() {
  //     isWaitingForResponse = true;
  //   });

  //   try {
  //     await ref.read(chatRepositoryProvider).sendMessageWithFiles(
  //           widget.walletId,
  //           chatThreadId!,
  //           message,
  //         );
  //   } catch (e) {
  //     setState(() {
  //       isWaitingForResponse = false;
  //     });
  //     AppSnackBar.showError(
  //       context: context,
  //       message: 'Failed to send messages.',
  //     );
  //   }
  // }

  Future<void> _confirmTransaction(int transactionId, String status) async {
    try {
      await ref.read(chatRepositoryProvider).confirmExtractedTransaction(
            transactionId: transactionId,
            walletId: widget.walletId,
            status: status,
          );
    } catch (e) {
      debugPrint('Error confirming transaction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Expense Assistant',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            color: Colors.white,
          ),
        ),
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(20),
        //   ),
        // ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorName.chatGradientStart,
                ColorName.chatGradientEnd,
              ],
            ),
            // borderRadius: BorderRadius.vertical(
            //   bottom: Radius.circular(20),
            // ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Toggle buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildToggleButton(
                    'Add Transaction',
                    isAddTransaction,
                    () => _changeTab(true),
                    Iconsax.receipt_add,
                  ),
                ),
                Expanded(
                  child: _buildToggleButton(
                    'Ask Mina',
                    !isAddTransaction,
                    () => _changeTab(false),
                    Iconsax.message_2,
                  ),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Consumer(
                    builder: (context, ref, child) {
                      final chatState = ref.watch(chatProvider);

                      return chatState.when(
                        initial: () => const Center(
                          child: Text(
                            'Start a conversation',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        loaded: (messages) {
                          if (messages.isEmpty) {
                            return const Center(
                              child: Text(
                                'No messages yet',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: messages.length,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    if (message == null) {
                                      return const SizedBox
                                          .shrink(); // Skip null messages
                                    }
                                    return MessageBubble(
                                      message: message,
                                      onConfirmTransaction: _confirmTransaction,
                                    );
                                  },
                                ),
                              ),
                              if (isWaitingForResponse)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, bottom: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      ColorName.blue),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Mina is thinking...',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        error: (error) => Center(child: Text(error.toString())),
                      );
                    },
                  ),
          ),

          // Input field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.image),
                  color: (_isUploadingImage || isWaitingForResponse)
                      ? Colors.grey
                      : ColorName.blue,
                  onPressed: (_isUploadingImage || isWaitingForResponse)
                      ? null
                      : _pickImage,
                ),

                if (_selectedImages != null && _selectedImages!.isNotEmpty)
                  GestureDetector(
                    onTap: _clearSelectedImages,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: ColorName.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: ColorName.blue.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_selectedImages!.length} ${_selectedImages!.length > 1 ? "images" : "image"}',
                            style: const TextStyle(
                              color: ColorName.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.close,
                            size: 12,
                            color: ColorName.blue,
                          ),
                        ],
                      ),
                    ),
                  ),

                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText:
                          _selectedImages != null && _selectedImages!.isNotEmpty
                              ? 'Enter message with image...'
                              : isAddTransaction
                                  ? 'Enter your mesage...'
                                  : 'Ask Mosa...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Nunito',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    enabled: !isWaitingForResponse && !_isUploadingImage,
                  ),
                ),

                // Nút gửi
                IconButton(
                  icon: _isUploadingImage
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: ColorName.blue),
                        )
                      : const Icon(Iconsax.send_2),
                  color: (isWaitingForResponse || _isUploadingImage)
                      ? Colors.grey
                      : ColorName.blue,
                  onPressed: (isWaitingForResponse || _isUploadingImage)
                      ? null
                      : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
      String text, bool isSelected, VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ColorName.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
