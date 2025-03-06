import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'providers/time_entry_provider.dart';
import 'screens/home_screen.dart';
import 'screens/project_management_screen.dart';
import 'screens/task_management_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({Key? key, required this.localStorage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark, // Ensure this matches ColorScheme
          primaryColor: Colors.teal,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.amber,
            brightness: Brightness.dark, // Match brightness here
          ),
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Colors.black,
                  displayColor: Colors.black,
                ),
          ),
          appBarTheme: AppBarTheme(
            color: Colors.teal,
            titleTextStyle: GoogleFonts.latoTextTheme(
              Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
            ).titleLarge,
            toolbarTextStyle: GoogleFonts.latoTextTheme(
              Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
            ).bodyMedium,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.amber,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(), // Main entry point, HomeScreen
          '/manage_projects': (context) =>
              ProjectManagementScreen(), // Route for managing categories
          '/manage_tasks': (context) =>
              TaskManagementScreen(), // Route for managing tags
        },
      ),
    );
  }
}