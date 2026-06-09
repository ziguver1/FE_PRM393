import 'package:flutter/material.dart';

import '../services/gemini_pet_ai_service.dart';
import '../services/local_pet_ai_service.dart';

class ChatProvider extends ChangeNotifier {
  final GeminiPetAiService _aiService = GeminiPetAiService();

  final List<AiChatMessage> messages = [
    AiChatMessage(
      text:
          'Xin chào! Mình là PawMart AI. Bạn có thể hỏi mình về thức ăn, snack, đồ chăm sóc, đồ chơi cho chó mèo.',
      isUser: false,
    ),
  ];

  bool isLoading = false;
  String? errorMessage;

  Future<void> sendMessage(String text) async {
    final message = text.trim();

    if (message.isEmpty) return;

    messages.add(AiChatMessage(text: message, isUser: true));
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final reply = await _aiService.generateReply(message);

      messages.add(
        AiChatMessage(
          text: reply,
          isUser: false,
        ),
      );
    } catch (e) {
      final localReply = LocalPetAiService().generateReply(message);

      messages.add(
        AiChatMessage(
          text:
              'Gemini AI đang tạm lỗi, mình dùng dữ liệu local của PawMart để trả lời trước:\n\n$localReply',
          isUser: false,
        ),
      );

      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    messages
      ..clear()
      ..add(
        AiChatMessage(
          text:
              'Xin chào! Mình là PawMart AI. Bạn có thể hỏi mình về thức ăn, snack, đồ chăm sóc, đồ chơi cho chó mèo.',
          isUser: false,
        ),
      );

    errorMessage = null;
    notifyListeners();
  }
}