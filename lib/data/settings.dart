///
/// Created by Kanjiu Akuma on 8/27/2020.
///

class Settings {
  final String language, region;

  Settings(this.language, this.region);

  factory Settings.load() {
    return Settings('en', 'EU');
  }

  copyWith({
    String language,
    String region,
  }) {
    return Settings(
      language ?? this.language,
      region ?? this.region,
    );
  }
}
