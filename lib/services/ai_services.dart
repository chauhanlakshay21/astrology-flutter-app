import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey = 'AIzaSyA5GoSWD9JYGcqrcnU2QhdX4wQxx2F8vj8';
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<String> getAstrologerResponse(
      String userMessage,
      String birthDetails,
      ) async {

    final prompt = '''Vedic astrologer. Birth: $birthDetails

Answer in 2-3 sentences. Be warm, specific. Sound human.

Q: $userMessage''';

    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.8,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 500,
            'responseModalities': ['TEXT'],
          },
          'systemInstruction': {
            'parts': [
              {'text': 'Respond directly without internal reasoning. Be concise and complete.'}
            ]
          }
        }),
      );

      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          String text = data['candidates'][0]['content']['parts'][0]['text'];
          return text.trim();
        }
      }

      return "Unable to connect. Please try again.";

    } catch (e) {
      print('Error: $e');
      return "Connection error. Please retry.";
    }
  }
}