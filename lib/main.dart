import 'package:flutter/material.dart';

import 'i18n/i18n.dart';
import 'screens/learn_screen.dart';
import 'screens/settings_screen.dart';
import 'store.dart';
import 'theme.dart';
import 'package:winter_core/winter_core.dart';

void main() => runWinterApp(repo: 'winter-language', appName: 'Winter Language', body: _main);

Future<void> _main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = AppStore();
  await store.load();
  runApp(WinterCrashBanner(child: StoreScope(store: store, child: const LanguageApp())));
}

class LanguageApp extends StatelessWidget {
  const LanguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    StoreScope.of(context); // перерисовка при смене языка интерфейса
    return MaterialApp(
      title: 'Winter Language',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _offerImport());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      StoreScope.read(context).flush();
    }
  }

  /// Первый запуск: предложить перенести прогресс из КБЖУ Трекера.
  Future<void> _offerImport() async {
    final store = StoreScope.read(context);
    if (store.importOffered || store.life.seenTotal() > 0) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(tr('Учился в КБЖУ Трекере?'), style: Txt.h2),
        content: Text(
          tr('Изучение языков переехало сюда. Можно перенести выученные слова и минуты: в КБЖУ открой вкладку «Учёба» → «Сохранить прогресс», потом выбери этот файл.'),
          style: Txt.small,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(tr('Начать с нуля'))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(tr('Выбрать файл'))),
        ],
      ),
    );
    if (!mounted) return;
    store.markImportOffered();
    if (yes == true) await importFromKbju(context);
  }

  @override
  Widget build(BuildContext context) => const LearnScreen();
}
