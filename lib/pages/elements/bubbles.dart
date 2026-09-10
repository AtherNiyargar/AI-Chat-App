import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class Bubble extends StatelessWidget {
  final int? isSent;
  final String? message;
  const Bubble({super.key, this.message, this.isSent});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSent == 1 ? .end : .start,
      children: [
        Column(
          crossAxisAlignment: isSent == 1 ? .end : .start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              constraints: BoxConstraints(
                // minWidth: 50,

                maxWidth: MediaQuery.sizeOf(context).width * 0.8,
              ),
              decoration: BoxDecoration(
                color: isSent == 1
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
                shape: .rectangle,

              ),

              child: message == null
                  ? const LinearProgressIndicator()
                  : SelectableText(message!),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message ?? ""));
              },
              icon: Icon(Icons.copy),
              constraints: BoxConstraints(),
              iconSize: 18,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primaryContainer.withAlpha(72),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
