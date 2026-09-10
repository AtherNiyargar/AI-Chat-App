import 'package:ai_chat_app/backend/messages_provider.dart';
import 'package:ai_chat_app/backend/variables.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyEndDrawer extends StatefulWidget {
  final BuildContext _context;
  const MyEndDrawer({super.key, required this._context});

  @override
  State<MyEndDrawer> createState() => _MyEndDrawerState();
}

class _MyEndDrawerState extends State<MyEndDrawer> {
  late final TextEditingController _controller;

  bool _value = Variables.useCustomKey;

  // Future _initValues()

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = Variables.customKey;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color.fromARGB(193, 0, 0, 0)),
      child: SafeArea(
        child: Column(
          spacing: 20,
          children: [
            const SizedBox(height: 10),
            Column(
              spacing: 15,
              children: [
                const Text(
                  "Use custom gemini key",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Switch(
                  value: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                textAlign: .center,
                controller: _controller,
                enabled: _value,

                style: TextStyle(
                  color: _value
                      ? const Color.fromARGB(216, 255, 255, 255)
                      : const Color.fromARGB(128, 255, 255, 255),
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hint: Text(
                    "Enter your gemini api key",
                    style: TextStyle(
                      fontSize: 18,
                      color: _value
                          ? const Color.fromARGB(207, 255, 255, 255)
                          : const Color.fromARGB(128, 255, 255, 255),
                    ),
                    textAlign: .center,
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: () async {
                final SharedPreferences pref =
                    await SharedPreferences.getInstance();
                await pref.setBool("useKey", _value);
                await pref.setString("customKey", _controller.text.trim());
                if(!context.mounted) return;
                Variables.useCustomKey = _value;
                Variables.customKey = _controller.text.trim();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            const Expanded(child: SizedBox.shrink()),

            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  FilledButton.icon(
                    icon: Icon(Icons.delete, color: Colors.white,),
                    onPressed: () {
                      widget._context.read<MessagesProvider>().deleteAllChat();
                      Variables.chatHistory.clear();
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(216, 244, 67, 54),
                      ),
                    ),
                    label: const Text(
                      "Delete chat history",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
