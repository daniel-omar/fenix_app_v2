import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fenix_app_v2/config/config.dart';
import 'package:logger/logger.dart';

void main() async {
  var logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
    level: Level.info, //Personaliza el formato de los mensajes
  );

  await Environment.initEnvironment();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
