import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperbrain/src/presentation/features/chatbot/cubit/chat_cubit.dart';
import 'package:paperbrain/src/presentation/features/chatbot/cubit/chat_states.dart';
import 'package:paperbrain/src/presentation/features/chatbot/widgets/chatbot_widgets.dart';
import 'package:paperbrain/src/presentation/features/home/cubits/pdf_cubit.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({super.key});

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final pdfCubit = context.read<PDFCubit>();
    final chatCubit = context.read<ChatCubit>();

    if (pdfCubit.currentPdfPath != null && !chatCubit.hasPDFLoaded) {
      await chatCubit.loadPDF(pdfCubit.currentPdfPath!);
      setState(() => _isInitialized = true);
    } else if (chatCubit.hasPDFLoaded) {
      setState(() => _isInitialized = true);
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatMessagesUpdatedState ||
                  state is ChatTypingState) {
                _scrollToBottom();
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const ChatHeader(),
                  Expanded(child: _buildChatContent(state)),
                  ChatInputBox(
                    controller: _controller,
                    onSend: _sendMessage,
                    isEnabled: _isInitialized && state is! ChatLoadingState,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChatContent(ChatState state) {
    if (state is ChatLoadingState) {
      return const ChatLoadingView();
    } else if (state is ChatErrorState) {
      return ChatErrorView(error: state.error);
    } else if (state is ChatMessagesUpdatedState || state is ChatTypingState) {
      final messages = state is ChatMessagesUpdatedState
          ? state.messages
          : (state as ChatTypingState).messages;
      final isTyping = state is ChatTypingState;

      return ChatMessagesList(
        messages: messages,
        scrollController: _scrollController,
        isTyping: isTyping,
      );
    } else if (_isInitialized) {
      return const EmptyChatView();
    } else {
      return const ChatLoadingView();
    }
  }
}