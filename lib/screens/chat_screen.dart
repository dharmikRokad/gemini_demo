import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String apiKey = dotenv.env['geminiApiKey'] ?? '';
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    log('api key => $apiKey');
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat With Gemini'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black38
                  : Colors.white54,
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                controller: _scrollController,
                itemBuilder: (context, index) => MessageWidget(
                  text: _generatedContent[index].text,
                  isFromUser: _generatedContent[index].fromUser,
                ),
                itemCount: _generatedContent.length,
              ),
            ),
          ),
          _buildBottomView(),
        ],
      ),
    );
  }

  _buildBottomView() => Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: buildTextField()),
            const SizedBox(width: 10),
            IconButton.filledTonal(
              onPressed: !_loading
                  ? () async {
                      _sendChatMessage(_textController.text);
                    }
                  : null,
              icon: Icon(
                CupertinoIcons.paperplane_fill,
                color: _loading
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
              ),
              style: IconButton.styleFrom(fixedSize: const Size(50, 50)),
            ),
          ],
        ),
      );

  buildTextField() => TextField(
        autofocus: false,
        focusNode: _textFieldFocus,
        maxLines: 10,
        minLines: 1,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: 'Enter a prompt...',
          // border: OutlineInputBorder(
          //   borderRadius: const BorderRadius.all(
          //     Radius.circular(14),
          //   ),
          //   borderSide: BorderSide(
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          // ),
          border: UnderlineInputBorder(),
        ),
        controller: _textController,
      );

  // void _scrollDown() {
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) => _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(
  //         milliseconds: 750,
  //       ),
  //       curve: Curves.easeOutCirc,
  //     ),
  //   );
  // }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });
    _textController.clear();

    try {
      _generatedContent.insert(0, (image: null, text: message, fromUser: true));
      _generatedContent
          .insert(0, (image: null, text: 'Generating...', fromUser: false));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.first = (image: null, text: text, fromUser: false);

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          // _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    this.image,
    this.text,
    required this.isFromUser,
  });

  final Image? image;
  final String? text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isFromUser ? Colors.blueGrey.shade50 : Colors.amber.shade50,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameView(),
          _buildMessageView(),
        ],
      ),
    );
  }

  _buildNameView() => Row(
        children: [
          CircleAvatar(
            backgroundColor:
                isFromUser ? Colors.blueGrey.shade300 : Colors.amber,
            child: Text(isFromUser ? 'U' : 'G'),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            isFromUser ? 'You' : 'Gemini',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      );

  _buildMessageView() => Row(
        children: [
          const SizedBox(width: 50),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text case final text?)
                  MarkdownBody(
                    data: text,
                  ),
                if (image case final image?) image,
              ],
            ),
          ),
        ],
      );
}
