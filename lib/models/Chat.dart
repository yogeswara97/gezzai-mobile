import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id; 
  final DateTime createdAt; 
  final String title; 

  Chat({
    required this.id,
    required this.createdAt,
    required this.title,
  });

  // Metode untuk membuat objek Chat dari Map (dari Firestore)
  factory Chat.fromMap(Map<String, dynamic> data, String documentId,) {
    return Chat(
      id: documentId,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      title: data['title'] as String,
    );
  }

  // Metode untuk mengubah objek Chat menjadi Map (untuk disimpan di Firestore)
  Map<String, dynamic> toMap() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'title': title,
    };
  }
}
