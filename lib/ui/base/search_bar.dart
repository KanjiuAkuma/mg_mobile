import 'package:flutter/cupertino.dart';

///
/// Created by Kanjiu Akuma on 9/2/2020.
///

import '../../mg_api/base/mg_request.dart';

import 'mg_view_state.dart';

/// Interface definition
abstract class SearchBar<T extends MgRequest> extends StatefulWidget implements RequestFactory<T> {
  double get height;
}

class SearchBarWrapper<T extends MgRequest> extends SliverPersistentHeaderDelegate implements RequestFactory<T> {
  final SearchBar<T> _searchBar;

  SearchBarWrapper(this._searchBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: _searchBar.height,
      width: double.infinity,
      child: OverflowBox(
        alignment: Alignment.bottomCenter,
        child: _searchBar,
      ),
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
  T createRequest(String region) {
    return _searchBar.createRequest(region);
  }
}
