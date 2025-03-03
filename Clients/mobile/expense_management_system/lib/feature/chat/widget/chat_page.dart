import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/gen/colors.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/feature/chat/provider/chat_provider.dart';
import 'package:flutter_boilerplate/feature/chat/widget/message_bubble.dart';
import 'package:iconsax/iconsax.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _messageController = TextEditingController();
  bool isAddTransaction = true;

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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
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
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
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
                    () => setState(() => isAddTransaction = true),
                    Iconsax.receipt_add,
                  ),
                ),
                Expanded(
                  child: _buildToggleButton(
                    'Ask Mina',
                    !isAddTransaction,
                    () => setState(() => isAddTransaction = false),
                    Iconsax.message_2,
                  ),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: Consumer(
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
                  )),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (messages) => ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return MessageBubble(message: message);
                    },
                  ),
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
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: isAddTransaction
                          ? 'Enter your transaction...'
                          : 'Ask Mina anything...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Nunito',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.send_2),
                  color: ColorName.blue,
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      ref.read(chatProvider.notifier).sendMessage(
                            _messageController.text,
                          );
                      _messageController.clear();
                    }
                  },
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
