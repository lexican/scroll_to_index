import 'package:flutter/material.dart';

class ReplyMessageWidget extends StatelessWidget {
  final String message;
  final Function(int) setReplyMessageIndex;
  const ReplyMessageWidget({
    super.key,
    required this.message,
    required this.setReplyMessageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reply",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 10,
            child: GestureDetector(
              onTap: () {
                setReplyMessageIndex(-1);
              },
              child: const Icon(
                Icons.clear,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
