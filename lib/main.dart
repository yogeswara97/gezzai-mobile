import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gezz_ai/firebase_options.dart';
import 'package:gezz_ai/screens/chat_screen.dart';
import 'package:gezz_ai/utils/styles/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final apiKey = dotenv.env['GEMINI_API_KEY']!;
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gezz AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primary,
      ),
      home: ChatScreen(
        apiKey: apiKey,
      ),
    );
  }
}