///
/// Created by Kanjiu Akuma on 8/22/2020.
///

import 'package:flutter/material.dart';

import '../../mg_api/requests/requests.dart' as Requests;

import '../views/search/search.dart' as ViewsSearch;

class Search extends StatelessWidget {

  final ViewsSearch.CharacterSearch _view;

  Search([Requests.Search request]): _view = ViewsSearch.CharacterSearch(request);

  @override
  Widget build(BuildContext context) {
    return _view;
  }

}