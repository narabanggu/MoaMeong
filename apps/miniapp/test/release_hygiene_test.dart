import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const maxFontBytes = 7 * 1024 * 1024;

  test('manifest/web에서 favicon 및 PWA 아이콘 참조를 사용하지 않는다', () {
    final manifestFile = File('web/manifest.json');
    expect(manifestFile.existsSync(), isTrue);

    final manifest =
        jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
    final icons = (manifest['icons'] as List<dynamic>? ?? <dynamic>[]);
    expect(icons, isEmpty, reason: 'manifest icons should be empty');

    const forbiddenIconFiles = <String>[
      'web/favicon.png',
      'web/favicon.svg',
      'web/favicon-16.png',
      'web/favicon-32.png',
      'web/favicon-64.png',
      'web/icons/Icon-192.png',
      'web/icons/Icon-512.png',
      'web/icons/Icon-maskable-192.png',
      'web/icons/Icon-maskable-512.png',
    ];
    for (final path in forbiddenIconFiles) {
      expect(
        File(path).existsSync(),
        isFalse,
        reason: 'forbidden icon file should not exist: $path',
      );
    }

    final indexFile = File('web/index.html');
    expect(indexFile.existsSync(), isTrue);
    final index = indexFile.readAsStringSync();
    expect(index.contains('rel="icon"'), isFalse);
    expect(index.contains('apple-touch-icon'), isFalse);
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
        .where((file) =>
            RegExp(r'\.(ttf|otf)$', caseSensitive: false).hasMatch(file.path))
        .toList();

    expect(fontFiles.length, 1,
        reason:
            'unexpected font files: ${fontFiles.map((file) => file.path).join(', ')}');
    expect(
      fontFiles.single.path
          .replaceAll('\\', '/')
          .endsWith('assets/fonts/SUIT/SUIT-Variable.ttf'),
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

  test('v0.3 컬러 토큰 고정값이 AppPalette에 반영되어 있다', () {
    final paletteFile = File('lib/core/theme/app_palette.dart');
    expect(paletteFile.existsSync(), isTrue);
    final palette = paletteFile.readAsStringSync();

    const requiredTokens = <String>[
      'static const Color white = Color(0xFFFFFFFF);',
      'static const Color paper = white;',
      'static const Color background = Color(0xFFF3F4F6);',
      'static const Color yellow = Color(0xFFFBD1A2);',
      'static const Color yellowSoft = Color(0xFFFFEFB1);',
      'static const Color orange = Color(0xFFF39A1F);',
      'static const Color orangeDeep = Color(0xFFE27C00);',
    ];

    for (final token in requiredTokens) {
      expect(
        palette.contains(token),
        isTrue,
        reason: 'missing required palette token: $token',
      );
    }
  });

  test('캐릭터 자산은 전신 단일 경로를 사용하고 얼굴 자산은 제거된다', () {
    final pubspecFile = File('pubspec.yaml');
    expect(pubspecFile.existsSync(), isTrue);
    final pubspec = pubspecFile.readAsStringSync();
    expect(pubspec.contains('assets/characters/maltipoo_mascot.svg'), isTrue);
    expect(pubspec.contains('assets/characters/maltipoo_face.svg'), isFalse);

    final mascotAsset = File('assets/characters/maltipoo_mascot.svg');
    final faceAsset = File('assets/characters/maltipoo_face.svg');
    expect(mascotAsset.existsSync(), isTrue);
    expect(faceAsset.existsSync(), isFalse);

    final brandingFile = File('lib/core/widgets/mascot_branding.dart');
    expect(brandingFile.existsSync(), isTrue);
    final branding = brandingFile.readAsStringSync();
    expect(
      branding.contains(
          "const String kMascotBodyAsset = 'assets/characters/maltipoo_mascot.svg';"),
      isTrue,
    );
    expect(branding.contains('SvgPicture.asset(\n      kMascotBodyAsset,'),
        isTrue);
    expect(branding.contains('class MascotFace'), isFalse);
    expect(branding.contains('kMascotFaceAsset'), isFalse);

    final appFile = File('lib/app.dart');
    expect(appFile.existsSync(), isTrue);
    final appCode = appFile.readAsStringSync();
    expect(appCode.contains('MascotFace('), isFalse);
  });

  test('v0.3 화이트 컴포넌트 + 라이트그레이 배경 정책이 테마에 반영된다', () {
    final themeFile = File('lib/core/theme/app_theme.dart');
    expect(themeFile.existsSync(), isTrue);
    final theme = themeFile.readAsStringSync();

    expect(theme.contains('scaffoldBackgroundColor: _background,'), isTrue);
    expect(theme.contains('color: AppPalette.white,'), isTrue);
    expect(theme.contains('fillColor: AppPalette.white,'), isTrue);
    expect(theme.contains('backgroundColor: AppPalette.white,'), isTrue);
  });
}
