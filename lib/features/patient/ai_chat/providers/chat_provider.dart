import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/services/gemini_service.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.read(geminiServiceProvider));
});

class ChatState {
  final List<Content> history;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.history,
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<Content>? history,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final GeminiService _geminiService;

  ChatNotifier(this._geminiService) : super(ChatState(history: [
    Content.model([TextPart("Hi there! I'm your MediCare AI Assistant. How can I help you today?")])
  ]));

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message immediately
    final userContent = Content.text(message);
    state = state.copyWith(
      history: [...state.history, userContent],
      isLoading: true,
      error: null,
    );

    try {
      final responseText = await _geminiService.chatWithAssistant(state.history.sublist(0, state.history.length - 1), message);
      
      final modelContent = Content.model([TextPart(responseText)]);
      state = state.copyWith(
        history: [...state.history, modelContent],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
