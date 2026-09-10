import 'package:ai_chat_app/backend/variables.dart';
import 'package:googleai_dart/googleai_dart.dart';

const myApiKey = "~~ your gemini key ~~";


Future fetchData(String message, String model) async {

final apiKey = Variables.useCustomKey ? Variables.customKey : myApiKey;
  Variables.chatHistory.add(Content.text(message));

  final client = GoogleAIClient.withApiKey(apiKey);

  try {
    final response = await client.models.generateContent(
      model: model,
      request: GenerateContentRequest(
        contents: Variables.chatHistory,
      ),

    );
    
    Variables.chatHistory.add(response.candidates!.first.content!);
    return response.text;

  }  
  finally {
    client.close();
  }
}
