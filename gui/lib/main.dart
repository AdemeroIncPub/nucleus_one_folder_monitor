import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers_initialized.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/util/style.dart';
import 'util/constants.dart';

Future<void> main() async {
  // Show loading
  runApp(const LoadingApp());

  // Initialize
  ProviderContainer container;
  try {
    container = await _initialize();
    // ignore: avoid_catches_without_on_clauses
  } catch (ex, stackTrace) {
    runApp(ErrorApp(
      error: ex,
      stackTrace: stackTrace,
    ));
    return;
  }

  // Show app
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

Future<ProviderContainer> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await initializeProviders(container);
  return container;
}

ThemeData _themeData() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.dark,
  );
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: productName,
      debugShowCheckedModeBanner: false,
      theme: _themeData(),
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: FractionallySizedBox(
                      heightFactor: 0.25,
                      widthFactor: 0.25,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class ErrorApp extends StatelessWidget {
  const ErrorApp({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    final hScroll = ScrollController();
    final vScroll = ScrollController();

    return MaterialApp(
      title: productName,
      debugShowCheckedModeBanner: false,
      theme: _themeData(),
      home: Scaffold(
        body: Scrollbar(
          controller: vScroll,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: vScroll,
            scrollDirection: Axis.vertical,
            child: Scrollbar(
              controller: hScroll,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: hScroll,
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: const EdgeInsets.all(screenPadding),
                  child: Text('$error\n$stackTrace'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: productName,
      debugShowCheckedModeBanner: false,
      theme: _themeData(),
      home: const MainScreen(),
    );
  }
}
