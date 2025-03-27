// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:gezz_ai/models/Chat.dart';
import 'package:gezz_ai/screens/chat_screen.dart';
import 'package:gezz_ai/services/chat_services.dart';
import 'package:gezz_ai/utils/styles/colors.dart';
import 'package:gezz_ai/utils/styles/typography.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibration/vibration.dart';

class ChatHistory extends StatefulWidget {
  final Function(String chatId) onChatSelected;
  final String? activeChat;
  final List<ChatMessage> chatHistory;
  final FocusNode textFieldFocus;
  final Function(String chatId) onChatDeleted;

  const ChatHistory({
    super.key,
    required this.onChatSelected,
    this.activeChat, 
    required this.chatHistory, 
    required this.onChatDeleted, 
    required this.textFieldFocus,
  });

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  late ChatServices _chatServices;
  late Future<List<Chat>> _chats;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chatServices = ChatServices();
    _chats = _chatServices.getAllChats();
    print('active chat ${widget.activeChat}');
  }

  Future<void> _loadChats() async {
    setState(() {
      _chats = _chatServices.getAllChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.secondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 10),
              child: Text('Chat History', style: AppTypography.title),
            ),
            // Drawer Items
            Expanded(
              child: FutureBuilder<List<Chat>>(
                future: _chats,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // return const ChatHistoryShimmer();
                    return Center(child: CircularProgressIndicator(color: AppColors.text,),);
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: AppTypography.message,
                    );
                  } else {
                    final chats = snapshot.data!;

                    //group chat by date
                    Map<String, List<Chat>> groupedChat = {};
                    for (var chat in chats) {
                      String dateKey =
                          DateFormat('yyyy-MM-dd').format(chat.createdAt);
                      if (groupedChat[dateKey] == null) {
                        groupedChat[dateKey] = [];
                      }
                      groupedChat[dateKey]!.add(chat);
                    }

                    // Mengubah Map menjadi List untuk diurutkan
                    List<String> sortedKeys = groupedChat.keys.toList();
                    sortedKeys.sort((a, b) =>
                        DateTime.parse(b).compareTo(DateTime.parse(a)));

                    return ListView.builder(
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, index) {
                        String dateKey = sortedKeys[index];
                        List<Chat> chatsForDate = groupedChat[dateKey]!;

                        // Sort chats for the specific date
                        chatsForDate.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                        String displayDate;
                        DateTime date = DateTime.parse(dateKey);
                        if (date.isToday()) {
                          displayDate = 'Today';
                        } else if (date.isYesterday()) {
                          displayDate = 'Yesterday';
                        } else {
                          displayDate = DateFormat('MMMM d, yyyy').format(date);
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                                indent: 15, color: AppColors.textSecondary),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                displayDate,
                                style: AppTypography.time,
                              ),
                            ),
                            ...chatsForDate
                                .map<Widget>((chat) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: widget.activeChat == chat.id
                                                  ? AppColors.primary
                                                  : null,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                chat.title,
                                                style: AppTypography.message,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              onTap: () async {
                                                bool? hasVibrator = await Vibration.hasVibrator();
                                                if (hasVibrator == true) {
                                                  Vibration.vibrate(duration: 100, amplitude: 50); // Getaran selama 100 ms
                                                }
                                                widget.onChatSelected(chat.id);

                                                widget.textFieldFocus.unfocus();
                                                Scaffold.of(context).closeDrawer();
                                          
                                              },
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            DeleteModalBottomSheet(context, chat.id);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: AppColors.danger,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                                .toList(), // Convert to List<Widget>
                          ],
                        );

                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> DeleteModalBottomSheet(BuildContext context, String chatId) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: AppColors.secondary,
          ),
          height: 300,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.delete_forever,
                  size: 60,
                  color: AppColors.danger,
                ),
                SizedBox(height: 16),
                Text(
                  'Delete Chat',
                  style: AppTypography.title
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "This can't be undone. Any created memories will be retained.",
                  style: AppTypography.time.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textSecondary,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: AppTypography.message
                              .copyWith(color: AppColors.text),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Delete",
                          style: AppTypography.message
                              .copyWith(color: Colors.white),
                        ),
                        onPressed: () async {
                          try {
                            Navigator.pop(context);
                            setState(() {
                              widget.chatHistory.clear();
                            });
                            widget.onChatDeleted(chatId);

                            print(widget.chatHistory);
                            await _chatServices.deleteChat(chatId);
                            await _chatServices.deleteAllMessage(chatId);
                            await _loadChats();
                            
                          } catch (e) {
                            print('Failed to delete chat: $e');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}


extension DateTimeExtensions on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return this.year == now.year &&
        this.month == now.month &&
        this.day == now.day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return this.year == yesterday.year &&
        this.month == yesterday.month &&
        this.day == yesterday.day;
  }
}
