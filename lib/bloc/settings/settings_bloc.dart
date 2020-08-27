///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_event.dart';
import 'settings_state.dart';

import '../../data/settings.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  SettingsBloc() : super(SettingsState(Settings.load()));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    // dummy function atm
    // as app settings can not be changed rn
  }

  Settings get settings {
    return state.settings;
  }

}