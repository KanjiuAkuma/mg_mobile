///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mg/mg_app.dart';

import 'bloc/locale/locale_bloc.dart';
import 'repositories/repository_locale.dart';

import 'bloc/settings/settings_bloc.dart';

class DebugBlocObserver extends BlocObserver {

  @override
  void onEvent(Bloc bloc, Object event) {
    print('DebugBlocObserver::onEvent: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print('DebugBlocObserver::onChange: {${change.currentState}} -> {${change.nextState}}');
    super.onChange(cubit, change);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('DebugBlocObserver::onError: $error');
    super.onError(cubit, error, stackTrace);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Remove for production
  Bloc.observer = DebugBlocObserver();

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
