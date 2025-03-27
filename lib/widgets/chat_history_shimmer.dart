import 'package:flutter/material.dart';
import 'package:gezz_ai/utils/styles/colors.dart';
import 'package:shimmer/shimmer.dart';

class ChatHistoryShimmer extends StatelessWidget {
  const ChatHistoryShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ShimmerColumn(),
        ShimmerColumn(),
        ShimmerColumn(),
        ShimmerColumn(),
        ShimmerColumn(),
      ],
    );
  }

  Column ShimmerColumn() {
    return Column(
        children: [
          const Divider(
              indent: 15, color: AppColors.textSecondary),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 20.0,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[800]!, 
                highlightColor: Colors.grey[700]!, 
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[600], 
                  ),
                  child: Center(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              width: double.infinity,
              height: 100.0,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[800]!, 
                highlightColor: Colors.grey[700]!, 
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[600], 
                  ),
                  child: Center(),
                ),
              ),
            ),
          ),
        ],
      );
  }
}
