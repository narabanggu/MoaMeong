import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const maxFontBytes = 7 * 1024 * 1024;
  const pngSignature = <int>[137, 80, 78, 71, 13, 10, 26, 10];

  ({int width, int height}) readPngDimensions(File file) {
    final bytes = file.readAsBytesSync();
    expect(bytes.length, greaterThanOrEqualTo(24));
    expect(bytes.sublist(0, 8), pngSignature);

    final header = ByteData.sublistView(bytes);
    final width = header.getUint32(16, Endian.big);
    final height = header.getUint32(20, Endian.big);
    return (width: width, height: height);
  }

  test('manifest 아이콘 참조가 유효하고 선언된 사이즈와 일치한다', () {
    final manifestFile = File('web/manifest.json');
    expect(manifestFile.existsSync(), isTrue);

    final manifest = jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
    final icons = (manifest['icons'] as List<dynamic>)
        .map((icon) => Map<String, dynamic>.from(icon as Map))
        .toList();

    const requiredManifestIcons = <String, String>{
      'icons/Icon-192.png': '192x192',
      'icons/Icon-512.png': '512x512',
      'icons/Icon-maskable-192.png': '192x192',
      'icons/Icon-maskable-512.png': '512x512',
    };

    for (final entry in requiredManifestIcons.entries) {
      final icon = icons.firstWhere((item) => item['src'] == entry.key);
      expect(icon['sizes'], entry.value);

      final iconPath = 'web/${entry.key}';
      final iconFile = File(iconPath);
      expect(iconFile.existsSync(), isTrue, reason: 'missing icon file: $iconPath');

      final dimensions = readPngDimensions(iconFile);
      final parts = entry.value.split('x');
      expect(dimensions.width, int.parse(parts[0]));
      expect(dimensions.height, int.parse(parts[1]));

      if (entry.key.contains('maskable')) {
        expect(icon['purpose'], 'maskable');
      }
    }

    const faviconPngSizes = <String, int>{
      'web/favicon-16.png': 16,
      'web/favicon-32.png': 32,
      'web/favicon-64.png': 64,
      'web/favicon.png': 32,
    };
    for (final entry in faviconPngSizes.entries) {
      final file = File(entry.key);
      expect(file.existsSync(), isTrue, reason: 'missing favicon file: ${entry.key}');

      final dimensions = readPngDimensions(file);
      expect(dimensions.width, entry.value);
      expect(dimensions.height, entry.value);
    }

    expect(File('web/favicon.svg').existsSync(), isTrue);
  });

  test('폰트 설정은 SUIT 단일 구성이고 폰트 용량은 7MB 이하를 유지한다', () {
    final pubspecFile = File('pubspec.yaml');
    expect(pubspecFile.existsSync(), isTrue);
    final pubspec = pubspecFile.readAsStringSync();

    expect(RegExp(r'family:\s*SUIT').hasMatch(pubspec), isTrue);
    expect(pubspec.contains('family: Pretendard'), isFalse);
    expect(pubspec.contains('family: Gaegu'), isFalse);
    expect(pubspec.contains('family: NotoSansKR'), isFalse);
    expect(pubspec.contains('assets/fonts/SUIT/SUIT-Variable.ttf'), isTrue);

    final fontDir = Directory('assets/fonts');
    expect(fontDir.existsSync(), isTrue);

    final fontFiles = fontDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => RegExp(r'\.(ttf|otf)$', caseSensitive: false).hasMatch(file.path))
        .toList();

    expect(fontFiles.length, 1, reason: 'unexpected font files: ${fontFiles.map((file) => file.path).join(', ')}');
    expect(
      fontFiles.single.path.replaceAll('\\', '/').endsWith('assets/fonts/SUIT/SUIT-Variable.ttf'),
      isTrue,
    );

    final totalFontBytes =
        fontFiles.fold<int>(0, (sum, file) => sum + file.lengthSync());
    expect(
      totalFontBytes <= maxFontBytes,
      isTrue,
      reason: 'font bytes exceeded 7MB limit: $totalFontBytes',
    );
  });
}
