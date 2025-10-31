import 'package:equatable/equatable.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatReadyState extends ChatState {}

class ChatMessagesUpdatedState extends ChatState {
  final List<ChatMessage> messages;

  ChatMessagesUpdatedState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatTypingState extends ChatState {
  final List<ChatMessage> messages;

  ChatTypingState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatErrorState extends ChatState {
  final String error;

  ChatErrorState(this.error);

  @override
  List<Object?> get props => [error];
}