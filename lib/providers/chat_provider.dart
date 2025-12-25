import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../models/birth_details_model.dart';
import '../services/ai_services.dart';

class ChatProvider with ChangeNotifier {
  final AIService _aiService = AIService();
  final List<MessageModel> _messages = [];
  BirthDetailsModel? _birthDetails;
  bool _isTyping = false;

  List<MessageModel> get messages => _messages;
  bool get isTyping => _isTyping;

  void setBirthDetails(BirthDetailsModel details) {
    _birthDetails = details;
    _messages.clear();
    // Add welcome message
    _messages.add(MessageModel(
      text:
      'Namaste ${details.fullName}! 🙏\n\nI am your Vedic astrologer. I have received your birth details. How may I guide you today regarding your ${details.currentConcern.toLowerCase()} concerns?',
      isUser: false,
    ));
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _birthDetails == null) return;

    // Add user message
    _messages.add(MessageModel(text: text, isUser: true));
    _isTyping = true;
    notifyListeners();

    try {
      // Get AI response
      final response = await _aiService.getAstrologerResponse(
        text,
        _birthDetails!.toFormattedString(),
      );

      // Add AI response
      _messages.add(MessageModel(text: response, isUser: false));
    } catch (e) {
      _messages.add(MessageModel(
        text: 'I apologize, but I am unable to connect at this moment. Please try again.',
        isUser: false,
      ));
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }
}