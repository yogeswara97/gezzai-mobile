import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gezz_ai/models/Chat.dart';
import 'package:gezz_ai/models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Chats Start

  Future<List<Chat>> getAllChats() async {
    QuerySnapshot snapshot = await _firestore.collection('Chats').get();
    return snapshot.docs
        .map((doc) => Chat.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<String> createChat() async {
    DocumentReference chatRef = await _firestore
        .collection('Chats')
        .add({'createdAt': FieldValue.serverTimestamp(), 'title': 'New Chat'});
    return chatRef.id;
  }

  Future<void> deleteChat(String chatId) async {
    try {
      DocumentReference chatRef = _firestore.collection('Chats').doc(chatId);
      await chatRef.delete();
      print('Chat with ID $chatId has been deleted successfully.');
    } catch (e) {
      print('Error deleting chat: $e');
      throw Exception('Failed to delete chat: $e');
    }
  }

  Future<void> updateChatTitle(String chatId, String title) async {
    try {
      await _firestore.collection('Chats').doc(chatId).update({
        'title': title
      });
    } catch (e) {
      print('Error updating chat title: $e');
    }
  }

  //Chats End

  Future<List<Message>> getAllMessages(String chatId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('Messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt')
        .get();
    return snapshot.docs
        .map((doc) =>
            Message.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> saveMessage(String chatId, String content,String role) async {
    try {
      await _firestore.collection('Messages').add({
        'chatId' : chatId,
        'content' : content,
        'role' : role,
        'createdAt' : FieldValue.serverTimestamp()
      });
    } catch (e) {
      print('Error saving message: $e');
    }
  }

  Future<void> deleteAllMessage(String chatId) async {
    try {
      QuerySnapshot snapshot = await _firestore
        .collection('Messages')
        .where('chatId', isEqualTo: chatId)
        .get();
      
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting messages: $e');
    }
  }
}
