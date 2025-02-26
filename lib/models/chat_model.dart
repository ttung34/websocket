// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatMessage {
  final String text;
  final bool isUSer;
  ChatMessage({
    required this.text,
    required this.isUSer,
  });

  ChatMessage copyWith({
    String? text,
    bool? isUSer,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUSer: isUSer ?? this.isUSer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'isUSer': isUSer,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] as String,
      isUSer: map['isUSer'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatMessage(text: $text, isUSer: $isUSer)';

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;
  
    return 
      other.text == text &&
      other.isUSer == isUSer;
  }

  @override
  int get hashCode => text.hashCode ^ isUSer.hashCode;
}
