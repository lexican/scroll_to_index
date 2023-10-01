import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:scroll_to_index_within_list_view/core/data/data.dart';

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
  }

  void _setReplyMessageIndex(int index) {
    setState(() {
      replyMessageIndex = index;
    });
  }

  void _sendMessage(String message) {
    setState(() {
      messages.add(message);
    });
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
                itemBuilder: (context, index) {
                  return AutoScrollTag(
                    key: ValueKey(index),
                    index: index,
                    controller: _autoScrollController,
                    highlightColor: Colors.blue.withOpacity(0.3),
                    child: _Bubble(
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
                  _ReplyMessageWidget(
                    message: messages[replyMessageIndex],
                  ),
                _TextInput(
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

class _Bubble extends StatelessWidget {
  final String message;
  final int index;
  final Function(int) setReplyMessageIndex;
  const _Bubble({
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

class _ReplyMessageWidget extends StatelessWidget {
  final String message;
  const _ReplyMessageWidget({required this.message});

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
              onTap: () {},
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

class _TextInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(int) scrollToIndex;
  final Function(String) sendMessage;
  const _TextInput({
    required this.controller,
    required this.scrollToIndex,
    required this.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Scroll to index",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  String message = controller.text;
                  if (message.isNotEmpty) {
                    sendMessage(message);
                  }
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
