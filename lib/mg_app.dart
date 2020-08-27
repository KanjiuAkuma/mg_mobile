///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mg/mg_api/requests/requests.dart' as Request;

import 'bloc/settings/settings_bloc.dart';
import 'bloc/region/region_bloc.dart';
import 'bloc/request/request_bloc.dart';

import 'ui/root.dart';

class MgApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegionBloc>(
          create: (_) => RegionBloc(BlocProvider.of<SettingsBloc>(context).settings.region),
        ),
        BlocProvider<RequestBloc<Request.Ranking24Hour>>(
          create: (_) => RequestBloc<Request.Ranking24Hour>(),
        ),
        BlocProvider<RequestBloc<Request.RankingClass>>(
          create: (_) => RequestBloc<Request.RankingClass>(),
        ),
        BlocProvider<RequestBloc<Request.RankingClears>>(
          create: (_) => RequestBloc<Request.RankingClears>(),
        ),
        BlocProvider<RequestBloc<Request.RankingParty>>(
          create: (_) => RequestBloc<Request.RankingParty>(),
        ),
        BlocProvider<RequestBloc<Request.RelatedCharacters>>(
          create: (_) => RequestBloc<Request.RelatedCharacters>(),
        ),
        BlocProvider<RequestBloc<Request.Search>>(
          create: (_) => RequestBloc<Request.Search>(),
        ),
        BlocProvider<RequestBloc<Request.UploadRecent>>(
          create: (_) => RequestBloc<Request.UploadRecent>(),
        ),
        BlocProvider<RequestBloc<Request.VerificationRestricted>>(
          create: (_) => RequestBloc<Request.VerificationRestricted>(),
        ),
      ],
      child: ViewRoot(),
    );
  }

}