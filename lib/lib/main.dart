import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gourmet/splach_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gourmet/menu_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDatabase();
  runApp(const MyApp());
}

Future<void> initDatabase() async {
  await copyDatabase();

  //get database object
  //connect to database
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = join(dir.path, 'menu.db');

  database = await $FloorMenuDatabase.databaseBuilder(dbPath).build();
}

late final MenuDatabase database;

Future<void> copyDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, 'menu.db');

  if (File(path).existsSync()) return;

  //copy from assets to this path
  ByteData data = await rootBundle.load('assets/menu.db');
  List<int> bytes = data.buffer.asUint8List(
    data.offsetInBytes,
    data.lengthInBytes,
  );
  await File(path).writeAsBytes(bytes);
}

final cloud = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplachScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.black12),
    );
  }
}
