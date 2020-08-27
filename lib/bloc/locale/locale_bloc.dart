///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_event.dart';
import 'locale_state.dart';

import '../../repositories/repository_locale.dart';

class LocaleBloc extends Bloc<SetLocaleEvent, LocaleState> {

  final RepositoryLocale repository;

  LocaleBloc(this.repository) : super(LocaleNoneState());

  @override
  Stream<LocaleState> mapEventToState(SetLocaleEvent event) async* {
    // signal locale is loading
    yield LocaleLoadingState();

    // load locale
    await repository.loadData(event.localeName);

    // signal locale loaded
    yield LocaleLoadedState();
  }

}