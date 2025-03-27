import 'package:flutter/material.dart';
import 'package:gezz_ai/models/message.dart';
import 'package:gezz_ai/services/chat_services.dart';
import 'package:gezz_ai/utils/styles/colors.dart';
import 'package:gezz_ai/utils/styles/typography.dart';
import 'package:gezz_ai/widgets/chat_history.dart';
import 'package:gezz_ai/widgets/chat_input_filed.dart';
import 'package:gezz_ai/widgets/message_widget.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vibration/vibration.dart';

class ChatMessage {
  final Content content;
  final String role;

  ChatMessage({required this.content, required this.role});
}

class ChatScreen extends StatefulWidget {
  final String apiKey;
  const ChatScreen({
    super.key,
    required this.apiKey,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final _scrollController = ScrollController();
  final _chatServices = ChatServices();

  List<ChatMessage> _chatHistory = [
    // response data
    // ChatMessage(content: Content.text("Hello"), role: 'user'),
    // ChatMessage(content: Content.text("Hi there!"), role: 'bot')
  ];

  bool _loading = false;
  bool _isSending = false;
  String? _activeChatId;


  @override
  void initState() {
    super.initState();

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: widget.apiKey,
    );
    _chatSession = _model.startChat();

    _textFieldFocus.addListener(() {
      if (_textFieldFocus.hasFocus) {
        _scrollDown();
      }
    });
  }

  List<ChatMessage> getChatHistory() {
    return _chatHistory; // Mengembalikan chat history saat ini
  }

  void _removeChat(String chatId){
    setState(() {
      _chatHistory.removeWhere((chat) => chat.content.parts
            .whereType<TextPart>()
            .map<String>((e) => e.text)
            .join('') == chatId
      );

      _activeChatId = null;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'GezzAI',
          style: AppTypography.title,
          textAlign: TextAlign.center,
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: AppColors.text,
              size: 25,
            ),
            onPressed: () async {
              bool? hasVibrator = await Vibration.hasVibrator();
              if (hasVibrator == true) {
                Vibration.vibrate(
                    duration: 100, amplitude: 50);
              }
              Scaffold.of(context).openDrawer(); 
            },
          );
        }),
        actions: [
          IconButton(
            icon: Icon(
              Icons.create_rounded, 
              color: _chatHistory.isEmpty ? AppColors.secondary : AppColors.text
            ),
            onPressed: () {
              _startNewChat(); 
              _textFieldFocus.unfocus();
            },
          ),
        ],
      ),
      drawer: ChatHistory(
          onChatSelected: (chatId) {
            _textFieldFocus.unfocus();
            _fetchChatMessages(chatId);
            print('Text field focus : ${_textFieldFocus}');
          },
          activeChat: _activeChatId, 
          chatHistory: getChatHistory(), 
          onChatDeleted: _removeChat,
          textFieldFocus: _textFieldFocus,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _chatHistory.isEmpty
                    ? Center(
                        child: Image.asset(
                        'assets/images/gezzzzai.jpeg',
                        height: 100,
                      ))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _chatHistory.length,
                        itemBuilder: (context, index) {
                          final ChatMessage chatMessage = _chatHistory[index];
                          final text = chatMessage.content.parts
                              .whereType<TextPart>()
                              .map<String>((e) => e.text)
                              .join('');
                          return MessageWidget(
                            text: text,
                            isForUser: chatMessage.role == 'user',
                            isLoading: chatMessage.role == 'bot' &&
                                _loading &&
                                index == _chatHistory.length - 1,
                          );
                        },
                      )),
            ChatInputFiled(
              controller: _textController,
              onSubmited: _sendChatMessage,
              onStopSending: _stopSending,
              loading: _loading,
              textFieldFocus: _textFieldFocus,
              isSending: _isSending,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _fetchChatMessages(String chatId) async {
    setState(() {
      _activeChatId = chatId; // Perbarui ID chat aktif
    });
    List<Message> messages = await _chatServices.getAllMessages(chatId);

    setState(() {
      _chatHistory = messages
          .map((msg) =>
              ChatMessage(content: Content.text(msg.content), role: msg.role))
          .toList();
    });
    _scrollDown();
  }

  Future<void> _startNewChat() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate(
          duration: 100, amplitude: 50);
    }
    setState(() {
      _chatHistory.clear();
      _activeChatId = null;
    });

    _textFieldFocus.requestFocus();
  }

  Future<void> _initializeChat() async {
    print('Chat Id : ${_activeChatId}');
    if (_activeChatId == null) {
      final newChatId = await _chatServices.createChat();
      setState(() {
        _activeChatId = newChatId;
      });
    }
    print('Chat Id : ${_activeChatId}');
  }

  Future<void> _sendChatMessage(String message) async {
    if (_textController.text.trim().isEmpty) return;
    
    //initilizechat
    _initializeChat();

    setState(() {
      _chatHistory
          .add(ChatMessage(content: Content.text(message), role: 'user'));
      _scrollDown();
      _loading = true;
      _isSending = true;
      _textController.clear();
      _textFieldFocus.unfocus();
    });

    // Add a temporary loading message
    _chatHistory
        .add(ChatMessage(content: Content.text("Loading..."), role: 'bot'));

    try {
      final response = await _chatSession.sendMessage(
        Content.text(message),
      );
      final text = response.text;

      if (text == null) {
        _showError('No Response From API');
        return;
      } else {
        setState(() {
          // Remove the loading message
          _chatHistory.removeLast();
          _chatHistory
              .add(ChatMessage(content: Content.text(text), role: 'bot'));
          _loading = false;
          _isSending = false;
          _scrollDown();
        });
      }

      //save to firebase
      await _chatServices.saveMessage(_activeChatId!, message, 'user');
      await _chatServices.saveMessage(_activeChatId!, text, 'bot');
      
      // Update chat title = first messsage
      if (_chatHistory.isNotEmpty) {
        String title = _chatHistory.first.content.parts
            .whereType<TextPart>()
            .map<String>((e) => e.text)
            .join('');

        await _chatServices.updateChatTitle(_activeChatId!, title);
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
        _isSending = false;
      });
    }
  }

  void _stopSending() {
    setState(() {
      _isSending = false; // Set status pengiriman menjadi false
      if (_chatHistory.isNotEmpty) {
        _chatHistory.removeLast(); // Hapus pesan loading jika ada
      }
    });
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _showError(String message) {
    _chatHistory.removeLast();
    _chatHistory.add(ChatMessage(content: Content.text(message), role: 'bot'));
  }
}
