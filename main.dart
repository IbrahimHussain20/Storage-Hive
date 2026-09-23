import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store/models/notes_models.dart';
import 'package:store/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web handles storage internally and does NOT use path_provider
  if (!kIsWeb) {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  // Open your Hive box here before running the app if you haven't opened it in HomeScreen
  // await Hive.openBox('myBoxName');
  Hive.registerAdapter(NotesModelAdapter());
  await Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive DB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
