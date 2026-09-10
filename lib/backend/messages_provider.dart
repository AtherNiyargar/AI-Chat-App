import 'package:ai_chat_app/backend/database_functionality.dart';
import 'package:ai_chat_app/backend/fetch_data_from_api.dart';
import 'package:ai_chat_app/backend/variables.dart';
import 'package:ai_chat_app/pages/elements/bubbles.dart';
import 'package:material_ui/material_ui.dart';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesProvider extends ChangeNotifier {
  DatabaseFunctionality? db;

  MessagesProvider() {
    db = DatabaseFunctionality();
  }

  final List<Widget> messages = [];

  Widget getMessage(int index) => messages[index];

  Future addNewMessage({
    required String message,
    required int isSent,
    required BuildContext context,
    required String model,
  }) async {
    messages.insert(0, Bubble(message: message, isSent: isSent));


    messages.insert(0, const Bubble());

    notifyListeners();

    try {
      final data = await fetchData(message, model);

      messages.removeAt(0);

      if (data != null) {
        await db!.insertData(message: message, isSent: isSent);
        messages.insert(0, Bubble(message: data, isSent: 0));
        await db!.insertData(message: data, isSent: 0);
      }

      notifyListeners();
    } on RateLimitException {

      messages.removeAt(0);
      messages.removeAt(0);
      Variables.chatHistory.removeLast();
      notifyListeners();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: const Text("This model has reached its daily quota"),
          actions: [
            FilledButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
      return false;
    } on AuthenticationException {
      messages.removeAt(0);
      messages.removeAt(0);
      Variables.chatHistory.removeLast();
      notifyListeners();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: const Text("Api Error"),
          actions: [
            FilledButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
      return false;
    } on ApiException catch (e) {
      messages.removeAt(0);
      messages.removeAt(0);
      Variables.chatHistory.removeLast();
      notifyListeners();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      String errorMessage;

      switch(e.statusCode) {
        case 0: errorMessage = "Connection Error";
        break;
        default: errorMessage = e.message;
      }

      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(errorMessage),
          actions: [
            FilledButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
      return false;
    }
    notifyListeners();
    return true;
  }

  Future populateChat() async {

    if(Variables.ispopulated) return;
    Variables.ispopulated = true;

    final SharedPreferences pref = await SharedPreferences.getInstance();
    Variables.selectedModel = pref.getString("selectedModel") ?? "gemini-3.1-flash-lite";
    Variables.useCustomKey = pref.getBool("useKey") ?? false;
    Variables.customKey = pref.getString("customKey") ?? "";
    messages.clear();

    final chats = await db!.getData();
    for (int i = 0; i < chats.length; i++) {
      messages.add(
        Bubble(
          message: chats[i]["message"] as String,
          isSent: chats[i]["isSent"] as int,
        ),
      );
    }
  }

  Future deleteAllChat() async {
    // Web comment
    // await db!.deleteDbEntries();
    messages.clear();
    notifyListeners();
  }
}
