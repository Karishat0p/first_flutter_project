import 'package:first_flutter_project/repositories/film_repository.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_project/presentation/home_page/home_page.dart';
import 'package:first_flutter_project/presentation/home_page/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_flutter_project/components/locale/l10n/app_locale.dart';
import 'package:first_flutter_project/presentation/locale_bloc/locale_bloc.dart';
import 'package:first_flutter_project/presentation/locale_bloc/locale_state.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:first_flutter_project/presentation/like_bloc/like_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(
          lazy: false,
          create: (context) => LocaleBloc(Locale(Platform.localeName)),
        ),
        BlocProvider<LikeBloc>(
          lazy: false,
          create: (_) => LikeBloc(),
        ),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            locale: state.currentLocale,
            localizationsDelegates: AppLocale.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
              useMaterial3: true,
            ),
            home: RepositoryProvider<FilmRepository>(
              lazy: true,
              create: (_) => FilmRepository(),
              child: BlocProvider<HomeBloc>(
                lazy: false,
                create: (context) => HomeBloc(context.read<FilmRepository>()),
                child: const MyHomePage(title: 'Саушкина К.С. МОАИСбд-31'),
              ),
            ),
          );
        },
      ),
    );
  }

}
