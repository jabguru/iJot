import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class VersionService {
  Future<Version> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    return Version.parse(version);
  }

  Future<bool> isGreaterThanV2() async {
    Version appVersion = await getAppVersion();
    Version version2 = Version(2, 0, 0);

    return appVersion > version2;
  }
}
