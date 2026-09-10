import 'package:ai_chat_app/backend/messages_provider.dart';
import 'package:ai_chat_app/backend/variables.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromptField extends StatefulWidget {
  const PromptField({super.key});

  @override
  State<PromptField> createState() => _PromptFieldState();
}

class _PromptFieldState extends State<PromptField> {
  late final TextEditingController _controller;
  // late final DatabaseFunctionality db;

  @override
  void initState() {
    super.initState();
    // db = DatabaseFunctionality();
    
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
  final String _selectedModel = Variables.selectedModel;

  bool buttonEnable = true;
  @override
  Widget build(BuildContext context) {
    final messageProvider = context.read<MessagesProvider>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(122),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 12),
        child: Column(
          spacing: 10,
          // crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            Row(
              spacing: 10,
              children: [
                const Text("Selected model:"),
                Flexible(
                  child: DropdownMenu(
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(35)),
                    ),
                    // alignmentOffset: ,
                  
                    menuStyle: const MenuStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(20)))),
                    ),
                    // initialSelection: "gemini-3.8-flash",
                        
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        label: "gemini-3.8-flash",
                        value: "gemini-3.8-flash",
                        labelWidget: const Text(
                          "\n--- Gemini 3.8 Flash ---\n20 Requests per day\n",
                          textAlign: .center,
                        ),
                      ),
                      DropdownMenuEntry(
                        value: "gemini-3.7-flash",
                        label: "gemini-3.7-flash",
                        labelWidget: const Text(
                          "\n--- Gemini 3.7 Flash ---\n20 Requests per day\n",
                          textAlign: .center,
                        ),
                      ),
                      DropdownMenuEntry(
                        value: "gemini-3.6-flash",
                        label: "gemini-3.6-flash ",
                        labelWidget: const Text(
                          "\n--- Gemini 3.6 Flash ---\n20 Requests per day\n",
                          textAlign: .center,
                        ),
                      ),
                      DropdownMenuEntry(
                        value: "gemini-3.5-flash",
                        label: "gemini-3.5-flash ",
                        labelWidget: const Text(
                          "\n--- Gemini 3.5 Flash ---\n20 Requests per day\n",
                          textAlign: .center,
                        ),
                      ),
                      DropdownMenuEntry(
                        value: "gemini-3.5-flash-lite",
                        label: "gemini-3.5-flash-lite ",
                        labelWidget: const Text(
                          "\n--- Gemini 3.5 Flash Lite ---\n500 Requests per day\n",
                          textAlign: .center,
                        ),
                      ),
                      DropdownMenuEntry(
                        value: "gemini-3.1-flash-lite",
                        label: "gemini-3.1-flash-lite",
                        labelWidget: const Text(
                          "\n--- Gemini 3.1 Flash Lite ---\n500 Requests per day\n",
                          textAlign: .center,
                        ),
                      ),
                      // DropdownMenuEntry(
                      //   value: "gemini-3-flash-preview",
                      //   label: "gemini-3-flash-preview",
                      //   labelWidget: const Text(
                      //     "\n--- Gemini 3 Flash Preview ---\n20 Requests per day",
                      //     textAlign: .center,
                      //   ),
                      // ),
                    ],
                    initialSelection: _selectedModel,
                    onSelected: (value) async {
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      pref.setString("selectedModel", value!);
                      Variables.selectedModel = value;
                    },
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    keyboardType: .multiline,
                    enabled: buttonEnable,
                    onTapUpOutside: (_) =>
                        FocusManager.instance.primaryFocus!.unfocus(),

                    decoration: const InputDecoration(

                      hintText: "Ask me anything...",
                      constraints: BoxConstraints(maxHeight: 200),
      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all( Radius.circular(35)),
                        borderSide: BorderSide(color: Colors.black, width: 2, ),
                      ),
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: buttonEnable
                      ? () async {
                          setState(() {
                            buttonEnable = false;
                          });
                          final message = _controller.text.trim();
                          if (message.isNotEmpty) {
                            final result = await messageProvider.addNewMessage(
                              model: _selectedModel,
                              context: context,
                              message: _controller.text.trim(),
                              isSent: 1,
                            );
                            setState(() {
                              buttonEnable = true;
                            });
                            if (result) {
                              _controller.clear();
                            }
                          }
                          setState(() {
                            buttonEnable = true;
                          });
                        }
                      : null,
      
                  icon: const Icon(Icons.send_rounded),
                  iconSize: 35,
                ),
                // MyButton(
                //   controller: _controller,
                //   messageProvider: messageProvider,
                //   model: ddValue,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
