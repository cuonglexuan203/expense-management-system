import 'dart:typed_data';

import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/auth/repository/token_repository.dart';
import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/feature/chat/provider/chat_provider.dart';
import 'package:expense_management_system/feature/chat/repository/chat_repository.dart';
import 'package:expense_management_system/feature/chat/widget/message_bubble.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ChatPage extends ConsumerStatefulWidget {
  final int walletId;

  const ChatPage({super.key, required this.walletId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage>
    with TickerProviderStateMixin {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool isAddTransaction = true;
  int? chatThreadId;
  bool isLoading = true;
  bool isWaitingForResponse = false;
  bool isSendButtonEnabled = false;

  bool _isInputExpanded = false;
  FocusNode _inputFocusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _buttonsAnimation;

  //Recording
  final _audioRecorder = AudioRecorder();
  String? _recordedAudioPath;
  bool _isRecording = false;

  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingImage = false;
  List<XFile>? _selectedImages;

  Future<void> _pickImage() async {
    try {
      final List<XFile>? images = await _imagePicker.pickMultiImage();

      if (images == null || images.isEmpty) return;

      setState(() {
        _selectedImages = images;
        _recordedAudioPath = null;
      });

      _onMessageChanged();
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
    _onMessageChanged();
  }

  Future<void> _startRecording() async {
    try {
      // Clear any selected images first
      if (_selectedImages != null && _selectedImages!.isNotEmpty) {
        setState(() {
          _selectedImages = null;
        });
      }

      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final filePath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.wav';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );

        setState(() {
          _isRecording = true;
        });
      } else {
        AppSnackBar.showError(
          context: context,
          message: 'Microphone permission is required.',
        );
      }
    } catch (e) {
      AppSnackBar.showError(
        context: context,
        message: 'Failed to start recording: ${e.toString()}',
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final filePath = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordedAudioPath = filePath;
      });

      // Haptic feedback for completed recording
      await HapticFeedback.mediumImpact();

      // Enable send button explicitly since we have an audio file
      _onMessageChanged();
    } catch (e) {
      AppSnackBar.showError(
        context: context,
        message: 'Failed to stop recording: ${e.toString()}',
      );
    }
  }

// Clear recording
  void _clearRecording() {
    setState(() {
      _recordedAudioPath = null;
    });
    _onMessageChanged();
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (photo == null) return;

      setState(() {
        _selectedImages = _selectedImages ?? [];
        _selectedImages!.add(photo);
        _recordedAudioPath = null;
      });

      _onMessageChanged();

      // Haptic feedback when photo is taken
      await HapticFeedback.mediumImpact();
    } catch (e) {
      AppSnackBar.showError(
        context: context,
        message: 'Can not take picture: ${e.toString()}',
      );
    }
  }

  Future<void> _sendMessage() async {
    var message = _messageController.text.trim();
    final hasImages = _selectedImages != null && _selectedImages!.isNotEmpty;
    final hasAudio = _recordedAudioPath != null;

    if (!hasImages && !hasAudio) {
      if (message.isEmpty) {
        AppSnackBar.showError(
          context: context,
          message: 'Please enter a message to send',
        );
        return;
      }

      try {
        final tempId = -DateTime.now().millisecondsSinceEpoch;

        final tempUserMessage = Message(
          id: tempId,
          chatThreadId: chatThreadId!,
          userId: 'current_user',
          role: 'User',
          content: message,
          createdAt: DateTime.now(),
          medias: [],
          extractedTransactions: [],
        );

        ref.read(chatProvider.notifier).addReceivedMessage(tempUserMessage);

        await ref.read(chatRepositoryProvider).sendMessage(
              widget.walletId,
              chatThreadId!,
              message,
            );
        setState(() {
          isWaitingForResponse = true;
        });
        _messageController.clear();
      } catch (e) {
        AppSnackBar.showError(
          context: context,
          message: 'Failed to send message: ${e.toString()}',
        );
      }
      return;
    }

    if (chatThreadId == null || isWaitingForResponse || _isUploadingImage)
      return;

    final tempId = -DateTime.now().millisecondsSinceEpoch;

    final tempUserMessage = Message(
      id: tempId,
      chatThreadId: chatThreadId!,
      userId: 'current_user',
      role: 'User',
      content: message,
      createdAt: DateTime.now(),
      medias: [],
      extractedTransactions: [],
    );

    ref.read(chatProvider.notifier).addReceivedMessage(tempUserMessage);

    _messageController.clear();

    setState(() {
      isWaitingForResponse = true;
    });

    try {
      final receivedMessage =
          await ref.read(chatRepositoryProvider).sendMessageViaWebSocket(
                widget.walletId,
                chatThreadId!,
                message,
              );

      if ((hasImages || hasAudio) && receivedMessage != null) {
        setState(() {
          _isUploadingImage = true;
        });

        ref.read(chatRepositoryProvider).setUploadProcessingStatus(true);

        try {
          List<XFile> mediaFiles = [];

          if (hasImages) {
            mediaFiles.addAll(_selectedImages!);
          }

          if (hasAudio) {
            mediaFiles.add(XFile(_recordedAudioPath!));
          }

          final uploadedMedia =
              await ref.read(chatRepositoryProvider).uploadMediaToMessage(
                    messageId: receivedMessage.id,
                    walletId: widget.walletId,
                    files: mediaFiles,
                  );

          final updatedMessage = receivedMessage.copyWith(
            medias: uploadedMedia,
          );

          ref.read(chatProvider.notifier).removeMessageById(tempId);
          ref.read(chatProvider.notifier).addReceivedMessage(updatedMessage);
        } finally {
          ref.read(chatRepositoryProvider).setUploadProcessingStatus(false);

          setState(() {
            _selectedImages = null;
            _recordedAudioPath = null;
            _isUploadingImage = false;
            _onMessageChanged();
          });
        }
      } else if (receivedMessage != null) {
        ref.read(chatProvider.notifier).updateMessage(receivedMessage);
      }
    } catch (e) {
      AppSnackBar.showError(
        context: context,
        message: 'Failed to send message',
      );
    } finally {
      setState(() {
        // isWaitingForResponse = false;
        _isUploadingImage = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
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

  void _onMessageChanged() {
    final message = _messageController.text.trim();
    final hasImages = _selectedImages != null && _selectedImages!.isNotEmpty;
    final hasAudio = _recordedAudioPath != null;

    setState(() {
      // Enable send button if there's text OR media (images or audio)
      isSendButtonEnabled = message.isNotEmpty || hasImages || hasAudio;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _scrollController.addListener(_onScroll);
    _messageController.addListener(_onMessageChanged);

    // Setup focus listener to expand input when focused
    _inputFocusNode.addListener(() {
      if (_inputFocusNode.hasFocus && !_isInputExpanded) {
        _expandInput();
      }
    });

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _buttonsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _audioRecorder.dispose();
    _messageController.removeListener(_onMessageChanged);
    _inputFocusNode.dispose();
    _animationController.dispose();
    ref.read(chatRepositoryProvider).disconnect();
    super.dispose();
  }

// Add these methods to handle input expansion/collapse
  void _expandInput() {
    setState(() {
      _isInputExpanded = true;
    });
    _animationController.forward();
  }

  void _collapseInput() {
    setState(() {
      _isInputExpanded = false;
      _inputFocusNode.unfocus();
    });
    _animationController.reverse();
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
        print('Access token: $accessToken');
        if (accessToken != null) {
          await ref.read(chatRepositoryProvider).connect(accessToken);

          ref.read(chatRepositoryProvider).setOnMessageReceivedCallback(() {
            // Always hide the thinking indicator when a system message is received
            setState(() {
              isWaitingForResponse = false;
            });
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

  // Image preview tile
  Widget _buildImagePreview(XFile image) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: FutureBuilder<Uint8List>(
              future: image.readAsBytes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  );
                }
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImages!.remove(image);
                  if (_selectedImages!.isEmpty) {
                    _selectedImages = null;
                  }
                  _clearSelectedImages();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Audio preview tile
  Widget _buildAudioPreview() {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorName.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorName.blue.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.audio_square, color: ColorName.blue),
              const SizedBox(height: 8),
              const Text(
                'Audio Recording',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorName.blue,
                  fontSize: 12,
                ),
              ),
              Text(
                'Tap to preview',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: _clearRecording,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Recording...',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Media previews (move this out of the layout to avoid animation issues)
            if ((_selectedImages != null && _selectedImages!.isNotEmpty ||
                    _recordedAudioPath != null) &&
                !isWaitingForResponse)
              Container(
                height: 100,
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (_selectedImages != null)
                      ..._selectedImages!
                          .map((image) => _buildImagePreview(image)),
                    if (_recordedAudioPath != null) _buildAudioPreview(),
                  ],
                ),
              ),

            // Input row with animation
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Toggle button (shows when input is expanded)
                if (_isInputExpanded)
                  Container(
                    margin: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                    decoration: BoxDecoration(
                      color: ColorName.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      iconSize: 22,
                      color: ColorName.blue,
                      onPressed: _collapseInput,
                      constraints:
                          const BoxConstraints(minHeight: 36, minWidth: 36),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),

                // Animated buttons container
                AnimatedBuilder(
                  animation: _buttonsAnimation,
                  builder: (context, child) {
                    return Visibility(
                        visible:
                            !_isInputExpanded || _buttonsAnimation.value < 0.1,
                        child: Row(
                          children: [
                            // Image picker button
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 4.0, bottom: 4.0),
                              decoration: BoxDecoration(
                                color:
                                    (_isUploadingImage || isWaitingForResponse)
                                        ? Colors.grey.withOpacity(0.2)
                                        : ColorName.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Iconsax.gallery),
                                iconSize: 22,
                                color:
                                    (_isUploadingImage || isWaitingForResponse)
                                        ? Colors.grey
                                        : ColorName.blue,
                                onPressed:
                                    (_isUploadingImage || isWaitingForResponse)
                                        ? null
                                        : _pickImage,
                                constraints: const BoxConstraints(
                                    minHeight: 36, minWidth: 36),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),

                            // Camera button
                            Container(
                              margin: const EdgeInsets.only(bottom: 4.0),
                              decoration: BoxDecoration(
                                color:
                                    (_isUploadingImage || isWaitingForResponse)
                                        ? Colors.grey.withOpacity(0.2)
                                        : ColorName.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Iconsax.camera),
                                iconSize: 22,
                                color:
                                    (_isUploadingImage || isWaitingForResponse)
                                        ? Colors.grey
                                        : ColorName.blue,
                                onPressed:
                                    (_isUploadingImage || isWaitingForResponse)
                                        ? null
                                        : _takePhoto,
                                constraints: const BoxConstraints(
                                    minHeight: 36, minWidth: 36),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),

                            // Audio recording button
                            Container(
                              margin: const EdgeInsets.only(bottom: 4.0),
                              decoration: BoxDecoration(
                                color: _isRecording
                                    ? Colors.red.withOpacity(0.1)
                                    : (_isUploadingImage ||
                                            isWaitingForResponse)
                                        ? Colors.grey.withOpacity(0.2)
                                        : ColorName.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: _isRecording
                                    ? const Icon(Iconsax.stop,
                                        color: Colors.red)
                                    : const Icon(Iconsax.microphone),
                                iconSize: 22,
                                color:
                                    (_isUploadingImage || isWaitingForResponse)
                                        ? _isRecording
                                            ? Colors.red
                                            : Colors.grey
                                        : ColorName.blue,
                                onPressed:
                                    (_isUploadingImage || isWaitingForResponse)
                                        ? null
                                        : _isRecording
                                            ? _stopRecording
                                            : _startRecording,
                                constraints: const BoxConstraints(
                                    minHeight: 36, minWidth: 36),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        ));
                  },
                ),

                // Expandable text field
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        // Make input taller when expanded
                        maxHeight: _isInputExpanded ? 120.0 : 80.0,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: TextField(
                          controller: _messageController,
                          focusNode: _inputFocusNode,
                          maxLines: null,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          enabled: !isWaitingForResponse &&
                              !_isUploadingImage &&
                              !_isRecording,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Nunito',
                          ),
                          decoration: InputDecoration(
                            hintText: (_selectedImages != null &&
                                        _selectedImages!.isNotEmpty) ||
                                    _recordedAudioPath != null
                                ? 'Enter message with media...'
                                : isAddTransaction
                                    ? 'Aa'
                                    : 'Ask Mosa...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'Nunito',
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12.0),
                            isCollapsed: true,
                          ),
                          onChanged: (text) {
                            _onMessageChanged();
                            // Expand input if not already expanded
                            if (!_isInputExpanded && text.isNotEmpty) {
                              _expandInput();
                            }
                          },
                          onTap: _expandInput,
                        ),
                      ),
                    ),
                  ),
                ),

                // Send button
                Container(
                  margin: const EdgeInsets.only(right: 4.0, bottom: 4.0),
                  decoration: BoxDecoration(
                    color: (isSendButtonEnabled && !isWaitingForResponse)
                        ? ColorName.blue
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Iconsax.send_2),
                    iconSize: 20,
                    color: (isSendButtonEnabled && !isWaitingForResponse)
                        ? Colors.white
                        : Colors.grey,
                    onPressed: (isSendButtonEnabled && !isWaitingForResponse)
                        ? _sendMessage
                        : null,
                    constraints:
                        const BoxConstraints(minHeight: 40, minWidth: 40),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.white),
          onPressed: () => context.go('/'),
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
                    'Ask Mosa',
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
                                      return const SizedBox.shrink();
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
                                            'Mosa is thinking...',
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

          // Recording indicator
          if (_isRecording)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: _buildRecordingIndicator(),
              ),
            ),

          _buildInputField(),
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
