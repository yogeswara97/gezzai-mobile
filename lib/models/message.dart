class Message {
  final String id; 
  final String chatId; 
  final String content; 
  final String role; 

  Message({
    required this.id,
    required this.chatId,
    required this.content,
    required this.role,
  });

  // Metode untuk membuat objek Message dari Map (dari Firestore)
  factory Message.fromMap(Map<String, dynamic> data, String documentId,) {
    return Message(
      id: documentId,
      chatId: data['chatId'] as String,
      content: data['content'] as String,
      role: data['role'] as String,
    );
  }

  // Metode untuk mengubah objek Message menjadi Map (untuk disimpan di Firestore)
  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'content': content,
      'role': role,
    };
  }
}