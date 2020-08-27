///
/// Created by Kanjiu Akuma on 8/27/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme.dart' as MgTheme;

import '../../bloc/region/region_bloc.dart';
import '../../bloc/region/region_state.dart';
import '../../bloc/region/region_event.dart';

import '../../data/regions.dart';

class MgAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const MgAppBar({Key key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionBloc, RegionState>(
      builder: (context, state) => AppBar(
        backgroundColor: MgTheme.Background.appBar,
        title: Text('mg/${regions[state.region]['name']}'),
        actions: [
          DropdownButton<String>(
            value: state.region,
            items: regions.keys
                .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (val) => BlocProvider.of<RegionBloc>(context).add(RegionChangedEvent(val)),
          ),
        ],
      ),
    );
  }
}
