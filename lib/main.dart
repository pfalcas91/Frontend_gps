import 'package:flutter/material.dart';
import 'package:flutter_gps/pages/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('pt'),
        Locale('ru'),
        Locale('es'),
        Locale('pl'),
        Locale('tr'),
        Locale('de'),
        Locale('fr'),
        Locale('nl'),
        Locale('zh'),
      ],
      path: 'assets/lang', // caminho para os ficheiros JSON de tradução
      fallbackLocale: const Locale('pt'), // muda para pt se preferires por defeito
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter GPS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashScreen(), // página inicial
    );
  }
}
