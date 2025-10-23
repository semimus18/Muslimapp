import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:muslimapp/routing/app_router.dart';
import 'package:muslimapp/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
    print('Environment file loaded successfully');
  } catch (e) {
    print('Could not load environment file: $e');
    // App masih boleh jalan tanpa .env file
  }
  
  runApp(const ProviderScope(child: IslamVerseApp()));
}

class IslamVerseApp extends ConsumerWidget {
  const IslamVerseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        fontFamily: 'Poppins',
        
      ),
    );
  }
}