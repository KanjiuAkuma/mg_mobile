///
/// Created by Kanjiu Akuma on 8/24/2020.
///

import '../../mg_api/base/mg_request.dart';

class RequestEvent<T extends MgRequest> {
  final T request;

  RequestEvent(this.request);

  @override
  String toString() {
    return '[${super.toString()}]: $request';
  }
}