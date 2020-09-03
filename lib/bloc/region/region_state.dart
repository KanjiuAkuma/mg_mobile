///
/// Created by Kanjiu Akuma on 8/27/2020.
///

class RegionState {
  final String region;

  RegionState(this.region);

  @override
  String toString() {
    return '[${super.toString()}]: $region';
  }
}