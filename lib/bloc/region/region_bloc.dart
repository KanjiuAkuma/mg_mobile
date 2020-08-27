///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import 'package:flutter_bloc/flutter_bloc.dart';

import 'region_event.dart';
import 'region_state.dart';

class RegionBloc extends Bloc<RegionChangedEvent, RegionState> {

  RegionBloc(String initialRegion) : super(RegionState(initialRegion));

  String get region {
    return state.region;
  }

  @override
  Stream<RegionState> mapEventToState(RegionChangedEvent event) async* {
    yield RegionState(event.region);
  }

}