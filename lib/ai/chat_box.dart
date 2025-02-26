import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_websocket/ai/message_bubble.dart';
import 'package:flutter_websocket/config/config.dart';
import 'package:flutter_websocket/models/chat_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBoxView extends StatefulWidget {
  const ChatBoxView({super.key});

  @override
  State<ChatBoxView> createState() => _ChatBoxViewState();
}

class _ChatBoxViewState extends State<ChatBoxView> {
  String apikeys = dotenv.env['API_KEY_GENIMI_AI'] ?? "No Api key found";
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> _message = [];

  void checkApi() {
    try {
      final apiKeys = EnvConfig.apiKeyGemini;
      if (apiKeys.isEmpty) {
        print("Api keys missing");
        return;
      }
    } catch (e) {
      print("APY error ${e}");
    }
  }

  final model = GenerativeModel(
    model: "gemini-pro",
    apiKey: EnvConfig.apiKeyGemini,
  );
  late final chat = model.startChat();

  void _sendMessager() async {
    if (controller.text.isEmpty) {
      return;
    }

    String messageText = controller.text;
    setState(
      () {
        _message.add(
          ChatMessage(text: messageText, isUSer: true),
        );
      },
    );
    controller.clear();

    try {
      final response = await chat.sendMessage(
        Content.text(messageText),
      );
      final responseText = response.text;
      setState(
        () {
          _message.add(
            ChatMessage(
                text: responseText ?? 'Không có phản hồi', isUSer: false),
          );
        },
      );
    } catch (e) {
      setState(
        () {
          _message.add(
            ChatMessage(text: "Đã xảy ra lỗi: ${e}", isUSer: false),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _message.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: _message[index],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessager,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
