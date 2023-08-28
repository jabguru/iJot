import 'dart:developer';
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

void main() {
  final pubspecFile = File('pubspec.yaml');
  final pubspecText = pubspecFile.readAsStringSync();
  final pubspecMap = loadYaml(pubspecText);
  final yamlEditor = YamlEditor(pubspecText);

  if (pubspecMap != null) {
    final String? currentVersion = pubspecMap['version'];

    if (currentVersion != null) {
      List<String> versionString = currentVersion.split('+');
      final newVersionCode = int.parse(versionString[1]) + 1;
      final newVersion = '${versionString[0]}+$newVersionCode';

      yamlEditor.update(['version'], newVersion);

      pubspecFile.writeAsStringSync(yamlEditor.toString());

      log('Build number (versionCode) incremented to $newVersion');
      return;
    }
  }
}
