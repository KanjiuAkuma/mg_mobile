///
/// Created by Kanjiu Akuma on 9/2/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mg_api/base/mg_request.dart';

import '../../bloc/region/region_bloc.dart';
import '../../bloc/region/region_state.dart';

import 'mg_view_state.dart';

/// Helper class. Yes i still hate warnings.
class _StringProperty {
  String value;

  _StringProperty(this.value);
}

/// Interface definition
abstract class SearchBar<T extends MgRequest> extends StatefulWidget implements RequestFactory<T> {
  double get height;

  final _StringProperty _regionProperty;

  SearchBar(String region) : _regionProperty = _StringProperty(region);

  void checkRegion(String region) {
    if (_regionProperty.value != region) {
      _regionProperty.value = region;
      onRegionChanged();
    }
  }

  /// Hook to invalidate data
  @protected
  void onRegionChanged() {}
}

class SearchBarWrapper<T extends MgRequest> extends SliverPersistentHeaderDelegate implements RequestFactory<T> {
  final SearchBar<T> _searchBar;

  SearchBarWrapper(this._searchBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocBuilder<RegionBloc, RegionState>(
      builder: (context, state) {
        // region might have changed...
        _searchBar.checkRegion(state.region);

        return Container(
          height: _searchBar.height,
          width: double.infinity,
          child: OverflowBox(
            alignment: Alignment.bottomCenter,
            child: _searchBar,
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  double get maxExtent {
    return _searchBar.height;
  }

  @override
  double get minExtent {
    return _searchBar.height;
  }

  @override
  T createRequest(String region, bool changed) {
    return _searchBar.createRequest(region, changed);
  }
}
