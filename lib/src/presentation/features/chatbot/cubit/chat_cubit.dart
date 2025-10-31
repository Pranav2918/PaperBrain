import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paperbrain/src/domain/repositories/app_repositories.dart';
import 'chat_states.dart';

class ChatCubit extends Cubit<ChatState> {
  final AppRepository _repo;
  final List<ChatMessage> _messages = [];

  ChatCubit(this._repo) : super(ChatInitialState());

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  Future<void> loadPDF(String pdfPath) async {
    try {
      emit(ChatLoadingState());

      final pdfText = await _repo.extractTextFromPdf(pdfPath);
      await _repo.initializeChatWithPDF(pdfText);

      emit(ChatReadyState());
    } catch (e) {
      emit(ChatErrorState('Failed to load PDF: ${e.toString()}'));
    }
  }

  // Send message to Gemini
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      // Add user message
      final userMessage = ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      );
      _messages.add(userMessage);
      emit(ChatMessagesUpdatedState(List.from(_messages)));

      emit(ChatTypingState(List.from(_messages)));

      final response = await _repo.sendMessage(message);

      final aiMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMessage);
      emit(ChatMessagesUpdatedState(List.from(_messages)));
    } catch (e) {
      final errorMessage = ChatMessage(
        text: 'Sorry, I encountered an error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
      emit(ChatMessagesUpdatedState(List.from(_messages)));
    }
  }

  void clearChat() {
    _messages.clear();
    _repo.clearChat();
    emit(ChatInitialState());
  }

  bool get hasPDFLoaded => _repo.hasPDFContext;
}
