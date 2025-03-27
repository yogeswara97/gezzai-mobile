import 'package:flutter/material.dart';
import 'package:gezz_ai/utils/styles/colors.dart';

class ChatInputFiled extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode textFieldFocus;
  final Function(String) onSubmited;
  final Function() onStopSending;
  final bool loading;
  final bool isSending;

  const ChatInputFiled(
      {super.key,
      required this.controller,
      required this.onSubmited,
      required this.loading,
      required this.textFieldFocus,
      required this.isSending, required this.onStopSending});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              style: TextStyle(color: Colors.white),
              autofocus: true,
              focusNode: textFieldFocus,
              decoration: textFieldDecoration(),
              controller: controller,
              maxLines: null,
              minLines: 1,
              onSubmitted: (value) {
                if (textFieldFocus.hasFocus) {
                  onSubmited(value);
                }
              },
            ),
          )),
          Container(
            width: 40,
            child: IconButton(
              icon: Icon(
                loading ? Icons.stop_circle : Icons.play_circle_filled_sharp,
                color: AppColors.text,
                size: 35,
              ),
              onPressed: () {
                if (isSending) {
                  // Jika sedang mengirim, hentikan pengiriman
                  onStopSending();
                } else {
                  // Jika tidak sedang mengirim, kirim pesan
                  onSubmited(controller.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration textFieldDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      hintText: 'Type a message...',
      hintStyle: TextStyle(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      enabledBorder: OutlineInputBorder(
        // Border ketika tidak dalam fokus
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: AppColors.secondary), // Ganti warna border di sini
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      filled: true,
      fillColor: AppColors.secondary,
    );
  }
}
