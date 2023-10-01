import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scroll_to_index_within_list_view/core/data/data.dart';
import 'package:scroll_to_index_within_list_view/core/widgets/bubble.dart';
import 'package:scroll_to_index_within_list_view/core/widgets/reply_message_widget.dart';
import 'package:scroll_to_index_within_list_view/core/widgets/text_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> messages = [...messageList];
  int replyMessageIndex = -1;

  final TextEditingController _controller = TextEditingController();
  final AutoScrollController _autoScrollController = AutoScrollController();

  Future<void> _scrollToIndex(int index) async {
    await _autoScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.end,
    );
    _autoScrollController.highlight(index);
  }

  void _setReplyMessageIndex(int index) {
    setState(() {
      replyMessageIndex = index;
    });
  }

  void _sendMessage(String message) {
    setState(() {
      messages.insert(0, message);
    });
    _controller.clear();
    _autoScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                controller: _autoScrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  return AutoScrollTag(
                    key: ValueKey(index),
                    index: index,
                    controller: _autoScrollController,
                    highlightColor: Colors.blue.withOpacity(0.3),
                    child: Bubble(
                      message: messages[index],
                      index: index,
                      setReplyMessageIndex: _setReplyMessageIndex,
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                if (replyMessageIndex != -1)
                  GestureDetector(
                    onTap: () {
                      _scrollToIndex(replyMessageIndex);
                    },
                    child: ReplyMessageWidget(
                      message: messages[replyMessageIndex],
                      setReplyMessageIndex: _setReplyMessageIndex,
                    ),
                  ),
                TextInput(
                  controller: _controller,
                  scrollToIndex: _scrollToIndex,
                  sendMessage: _sendMessage,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _autoScrollController.dispose();
  }
}
