///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mg/mg_app.dart';

import 'bloc/locale/locale_bloc.dart';
import 'repositories/repository_locale.dart';

import 'bloc/settings/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String appLocale = 'en';
  final RepositoryLocale repositoryLocale = RepositoryLocale();
  await repositoryLocale.loadData(appLocale);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SettingsBloc>(
        create: (_) => SettingsBloc(),
      ),
      BlocProvider<LocaleBloc>(
        create: (_) => LocaleBloc(repositoryLocale),
      )
    ],
    child: RepositoryProvider<RepositoryLocale>(
      create: (_) => repositoryLocale,
      child: MgApp(),
    ),
  ));
}
