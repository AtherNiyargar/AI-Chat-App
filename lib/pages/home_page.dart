import 'package:ai_chat_app/backend/messages_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final messageProvider = context.watch<MessagesProvider>();

    return
    Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: ListView.builder(
            reverse: true,
            // dragStartBehavior: .down,
            // controller: ScrollController(),
            // physics: BouncingScrollPhysics(),
            itemCount: messageProvider.messages.length,
            itemBuilder: (context, index) {
              final message = messageProvider.getMessage(index);
              return message; 
            },
          ),
        ),
      ),
    );
  }
}

