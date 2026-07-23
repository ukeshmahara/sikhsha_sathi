import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sikhsha_sathi/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:sikhsha_sathi/features/chatbot/presentation/state/chatbot_state.dart';
import 'package:sikhsha_sathi/features/chatbot/presentation/view_model/chatbot_view_model.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class ChatbotPage extends ConsumerStatefulWidget {
  const ChatbotPage({super.key});

  @override
  ConsumerState<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends ConsumerState<ChatbotPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatbotViewModelProvider.notifier).loadHistory();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    _scrollToBottom();

    final success = await ref.read(chatbotViewModelProvider.notifier).sendMessage(text);
    _scrollToBottom();

    if (!success && mounted) {
      final errorMessage = ref.read(chatbotViewModelProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Could not send message')),
      );
    }
  }

  void _confirmClearChat() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear conversation?'),
        content: const Text('This will delete your entire chat history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(chatbotViewModelProvider.notifier).clearChat();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatbotViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _kPrimaryBlue,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/icons/chatbot.png',
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text('AI school assistant'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: state.messages.isEmpty ? null : _confirmClearChat,
            tooltip: 'Clear conversation',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(state),
          ),
          _buildInputBar(state),
        ],
      ),
    );
  }

  Widget _buildMessageList(ChatbotState state) {
    if (state.status == ChatbotStatus.loading && state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.messages.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/icons/chatbot.png',
                  width: 72,
                  height: 72,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ask me anything about schools, admissions,\nor just say hello!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(14),
      itemCount: state.messages.length + (state.status == ChatbotStatus.sending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.messages.length) {
          // typing indicator while waiting for the assistant's reply
          return _buildTypingIndicator();
        }

        final message = state.messages[index];
        return _buildBubble(message);
      },
    );
  }

  Widget _buildBubble(ChatMessageEntity message) {
    final isUser = message.role == ChatRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? _kPrimaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 14),
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const SizedBox(
          width: 20,
          height: 12,
          child: Center(
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(ChatbotState state) {
    final isSending = state.status == ChatbotStatus.sending;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: !isSending,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isSending ? null : _send,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSending ? Colors.grey.shade300 : _kPrimaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}