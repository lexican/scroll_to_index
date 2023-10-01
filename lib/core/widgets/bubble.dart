import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  final String message;
  final int index;
  final Function(int) setReplyMessageIndex;
  const Bubble({
    super.key,
    required this.message,
    required this.index,
    required this.setReplyMessageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(index),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) {
        setReplyMessageIndex(index);
        return Future.value(false);
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 20,
          right: 48,
          left: 20,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
