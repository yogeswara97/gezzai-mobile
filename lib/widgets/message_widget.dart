import 'package:flutter/material.dart';
import 'package:gezz_ai/utils/styles/colors.dart';
import 'package:gezz_ai/utils/styles/typography.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {super.key,
      required this.text,
      required this.isForUser,
      required this.isLoading});

  final String text;
  final bool isForUser;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isForUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          constraints: BoxConstraints(maxWidth: isForUser ? 280 : 520),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: isForUser ? AppColors.secondary : AppColors.primary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isForUser) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: SizedBox(
                        height: 34,
                        width: 34,
                        child: Image.asset('assets/images/gezzzzai.png')
                      ),
                    ),
                    Flexible(
                        child: isLoading
                            ? const SizedBox(
                              width: 30,
                              height: 30,
                              child: LoadingIndicator(
                                  indicatorType: Indicator.ballScale,
                                  colors: [Colors.white],
                                  strokeWidth: 2,
                                  backgroundColor: Colors.black,
                                  pathBackgroundColor: Colors.black),
                            )
                            : Text(
                                text,
                                style: AppTypography.message,
                              ))
                  ],
                ),
              ] else ...[
                Text(
                  text,
                  style: AppTypography.message,
                ),
              ],
            ],
          ),
        ))
      ],
    );
  }
}
