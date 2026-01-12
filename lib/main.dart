import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi_tick/models/medicine.dart';
import 'package:medi_tick/providers/medicine_provider.dart';
import 'package:medi_tick/screens/home_screen.dart';
import 'package:medi_tick/services/notification_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MedicineAdapter());

  await Hive.openBox<Medicine>('medicines');

  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MedicineProvider())],

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.teal,
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.orange, // Constraint Met
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
              .copyWith(
                secondary: Colors.orange, // For accents
              ),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
