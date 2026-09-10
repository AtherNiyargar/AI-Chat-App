import 'package:ai_chat_app/backend/messages_provider.dart';
import 'package:ai_chat_app/pages/elements/prompt_field.dart';
import 'package:ai_chat_app/pages/home_page.dart';
import 'package:ai_chat_app/pages/my_end_drawer.dart';

import 'package:dynamic_color/dynamic_color.dart';
// import 'package:material_ui/material_ui.dart' as mu;
import 'package:material_ui/material_ui.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ColorScheme? lightColorScheme;
        ColorScheme? darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF1E88E5));
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Color(0xFF1E88E5),
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          theme: ThemeData(colorScheme: lightColorScheme),
          darkTheme: ThemeData(colorScheme: darkColorScheme),
          home: ChangeNotifierProvider(
            create: (context) => MessagesProvider(),

            child: Builder(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("AI chat app"),
                    centerTitle: true,
                  ),
                  // drawer: Icon(Icons.abc_outlined),
                  endDrawer: MyEndDrawer(context: context),
                  body: SafeArea(
                    child: FutureBuilder(
                      future: context.read<MessagesProvider>().populateChat(),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState == .done) {
                          return Column(
                            children: [
                              context.watch<MessagesProvider>().messages.isEmpty
                                  ? const Expanded(
                                      child: Center(
                                        child: Text("Start with anything"),
                                      ),
                                    )
                                  : const HomePage(),
                              const PromptField(),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
