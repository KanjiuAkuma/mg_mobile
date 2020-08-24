///
/// Created by Kanjiu Akuma on 8/22/2020.
///

class MGRequest {
  final String _apiEndpoint;
  final Map<String, dynamic> _parameters;

  MGRequest(this._apiEndpoint, this._parameters);

  /// Hook to modify response json before returning
  List<dynamic> parseResponseJson(List<dynamic> responseJson) {
    return responseJson;
  }

  /// Creates a usable url from given data
  String build() {
    return '$_apiEndpoint?${_parameters.entries.map((e) => '${e.key}=${e.value}').join('&')}';
  }

  @override
  String toString() {
    return "Request '${build()}'";
  }
}
