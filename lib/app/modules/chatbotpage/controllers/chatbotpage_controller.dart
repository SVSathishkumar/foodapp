import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatbotpageController extends GetxController {
  // Users
  final ChatUser myself = ChatUser(id: '1', firstName: 'Tom');
  final ChatUser bot = ChatUser(id: '2', firstName: 'Gemini');

  // Chat messages & typing
  final RxList<ChatMessage> allMessages = <ChatMessage>[].obs;
  final RxList<ChatUser> typing = <ChatUser>[].obs;

  // Gemini API details
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyDP44VfvPWKWEvakEN222NJvyUnPqHz6TU';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Handles user message and Gemini API response
  Future<void> getData(ChatMessage message) async {
    // Add user's message
    allMessages.insert(0, message);
    typing.add(bot);
    update();

    final requestPayload = {
      "contents": [
        {
          "parts": [
            {"text": message.text}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        final String botReply =
            result['candidates'][0]['content']['parts'][0]['text'];

        final botMessage = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: botReply,
        );

        allMessages.insert(0, botMessage);
      } else {
        allMessages.insert(
          0,
          ChatMessage(
            user: bot,
            createdAt: DateTime.now(),
            text: "⚠️ Error ${response.statusCode}: Unable to get a response.",
          ),
        );
      }
    } catch (e) {
      allMessages.insert(
        0,
        ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: "❌ Exception: $e",
        ),
      );
    } finally {
      typing.remove(bot);
      update();
    }
  }

  /// Simulated image generation or echo logic (fallback/test)
  void getDatas(ChatMessage message) {
    allMessages.insert(0, message);
    update();

    if (message.text.toLowerCase().contains("generate image")) {
      final imageUrl =
          "https://placehold.co/300x300.png?text=Generated+Image"; // Replace with real image generation API

      allMessages.insert(
        0,
        ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          medias: [
            ChatMedia(
              url: imageUrl,
              type: MediaType.image,
              fileName: 'GeneratedImage.png',
            )
          ],
        ),
      );
    } else {
      allMessages.insert(
        0,
        ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: "You said: ${message.text}",
        ),
      );
    }

    update();
  }
}
