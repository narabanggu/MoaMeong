import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miniapp/app.dart';
import 'package:miniapp/core/widgets/mascot_branding.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final fixedNow = DateTime(2026, 2, 16, 12, 0, 0);

  Future<void> pumpApp(
    WidgetTester tester, {
    required List<Map<String, dynamic>> subscriptions,
    DateTime Function()? nowProvider,
    bool? reducedMotionOverride,
  }) async {
    SharedPreferences.setMockInitialValues(
      <String, Object>{
        'subscription_state_v1': jsonEncode(
          <String, dynamic>{
            'subscriptions': subscriptions,
          },
        ),
      },
    );

    // Recreate app state with fresh mock storage values per scenario.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      MiniAppRoot(
        nowProvider: nowProvider ?? () => fixedNow,
        reducedMotionOverride: reducedMotionOverride,
      ),
    );
    // Repeating mascot animations never fully settle, so pump a few frames instead.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 30));
    }
  }

  Map<String, dynamic> subscriptionJson({
    required String id,
    required String name,
    required int daysUntilDue,
    required double amount,
  }) {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amount': amount,
      'cycle': 'monthly',
      'cycleDays': 30,
      'nextBillingDate':
          fixedNow.add(Duration(days: daysUntilDue)).toIso8601String(),
      'status': 'active',
      'importance': 'normal',
      'category': 'streaming',
    };
  }

  testWidgets('단일 홈 화면과 우상단 액션 버튼이 표시된다', (WidgetTester tester) async {
    await pumpApp(tester, subscriptions: const <Map<String, dynamic>>[]);

    expect(find.textContaining('현재 구독'), findsOneWidget);
    expect(find.text('월환산 총액'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline_rounded), findsOneWidget);
    expect(find.byType(MascotFace), findsOneWidget);
    expect(find.byType(PlainEmptyState), findsOneWidget);
    expect(find.text('홈'), findsNothing);
    expect(find.text('요약'), findsNothing);
  });

  testWidgets('스크롤 시 Hero 캐릭터가 축소된다 (애니메이션 트리거)', (WidgetTester tester) async {
    final subscriptions = List<Map<String, dynamic>>.generate(
      12,
      (index) => subscriptionJson(
        id: 'sub_$index',
        name: '구독$index',
        daysUntilDue: 14 + index,
        amount: 5000 + (index * 1000).toDouble(),
      ),
    );

    await pumpApp(tester, subscriptions: subscriptions);

    final initialMascot = tester.widget<MascotFace>(
      find.byType(MascotFace),
    );
    expect(initialMascot.size, closeTo(122, 0.01));

    await tester.drag(find.byType(ListView), const Offset(0, -30));
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.byType(MascotFace), findsOneWidget);
    final collapsedMascot = tester.widget<MascotFace>(
      find.byType(MascotFace),
    );
    expect(collapsedMascot.size, lessThan(initialMascot.size));
    expect(collapsedMascot.size, greaterThan(82));
  });

  testWidgets('임박 결제 유무에 따라 Hero 상태가 전환된다 (상태 전환)',
      (WidgetTester tester) async {
    await pumpApp(
      tester,
      subscriptions: <Map<String, dynamic>>[
        subscriptionJson(
          id: 'sub_relaxed',
          name: '여유결제',
          daysUntilDue: 20,
          amount: 12000,
        ),
      ],
    );

    expect(find.text('오늘의 요약'), findsOneWidget);
    expect(find.textContaining('7일 내 결제'), findsNothing);

    await pumpApp(
      tester,
      subscriptions: <Map<String, dynamic>>[
        subscriptionJson(
          id: 'sub_imminent',
          name: '임박결제',
          daysUntilDue: 2,
          amount: 17000,
        ),
      ],
    );

    expect(find.text('이번 주 체크'), findsOneWidget);
    expect(find.textContaining('7일 내 결제 1건'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });

  testWidgets('캐릭터 탭 반응은 중첩되지 않고 360ms 내 종료된다', (WidgetTester tester) async {
    await pumpApp(
      tester,
      subscriptions: <Map<String, dynamic>>[
        subscriptionJson(
          id: 'sub_react',
          name: '반응테스트',
          daysUntilDue: 2,
          amount: 15000,
        ),
      ],
    );

    expect(find.byKey(const ValueKey<String>('mascot-state-hint-urgent')),
        findsOneWidget);
    final mascotFinder = find.byType(AnimatedMascotFace);
    expect(mascotFinder, findsOneWidget);

    await tester.tap(mascotFinder);
    await tester.pump();
    expect(find.byKey(const ValueKey<String>('mascot-state-reacting')),
        findsOneWidget);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(mascotFinder);
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 220));
    expect(find.byKey(const ValueKey<String>('mascot-state-reacting')),
        findsNothing);
    expect(find.byKey(const ValueKey<String>('mascot-state-hint-urgent')),
        findsOneWidget);
  });

  testWidgets('캐릭터 반응 쿨다운은 주입된 nowProvider 기준으로 동작한다',
      (WidgetTester tester) async {
    var now = fixedNow;

    await pumpApp(
      tester,
      subscriptions: <Map<String, dynamic>>[
        subscriptionJson(
          id: 'sub_cooldown',
          name: '쿨다운테스트',
          daysUntilDue: 2,
          amount: 15000,
        ),
      ],
      nowProvider: () => now,
    );

    final mascotFinder = find.byType(AnimatedMascotFace);
    expect(mascotFinder, findsOneWidget);

    await tester.tap(mascotFinder);
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('mascot-state-reacting')),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 380));
    expect(
      find.byKey(const ValueKey<String>('mascot-state-reacting')),
      findsNothing,
    );

    now = now.add(const Duration(milliseconds: 500));
    await tester.tap(mascotFinder);
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('mascot-state-reacting')),
      findsNothing,
    );

    now = now.add(const Duration(milliseconds: 250));
    await tester.tap(mascotFinder);
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('mascot-state-reacting')),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 380));
    expect(
      find.byKey(const ValueKey<String>('mascot-state-hint-urgent')),
      findsOneWidget,
    );
  });

  testWidgets('상단 액션 버튼은 접근성 라벨과 최소 탭 타깃을 가진다', (WidgetTester tester) async {
    await pumpApp(tester, subscriptions: const <Map<String, dynamic>>[]);

    expect(find.byTooltip('알림 열기'), findsOneWidget);
    expect(find.byTooltip('구독 추가'), findsOneWidget);

    final buttonFinder = find.byType(IconButton);
    expect(buttonFinder, findsAtLeastNWidgets(2));

    final firstButtonSize = tester.getSize(buttonFinder.at(0));
    final secondButtonSize = tester.getSize(buttonFinder.at(1));
    expect(firstButtonSize.width, greaterThanOrEqualTo(44));
    expect(firstButtonSize.height, greaterThanOrEqualTo(44));
    expect(secondButtonSize.width, greaterThanOrEqualTo(44));
    expect(secondButtonSize.height, greaterThanOrEqualTo(44));
  });

  testWidgets('키보드 Tab 포커스가 알림 -> 구독 추가 순서로 이동한다', (WidgetTester tester) async {
    await pumpApp(tester, subscriptions: const <Map<String, dynamic>>[]);

    final alertsFinder = find.byKey(
      const ValueKey<String>('top-action-alerts'),
    );
    final addFinder = find.byKey(
      const ValueKey<String>('top-action-add'),
    );

    expect(alertsFinder, findsOneWidget);
    expect(addFinder, findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    final alertsButtonAfterFirstTab = tester.widget<IconButton>(alertsFinder);
    expect(alertsButtonAfterFirstTab.focusNode?.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    final alertsButtonAfterSecondTab = tester.widget<IconButton>(alertsFinder);
    final addButtonAfterSecondTab = tester.widget<IconButton>(addFinder);
    expect(alertsButtonAfterSecondTab.focusNode?.hasFocus, isFalse);
    expect(addButtonAfterSecondTab.focusNode?.hasFocus, isTrue);
  });

  testWidgets('구독 목록 및 알림 드로어에는 캐릭터가 추가 노출되지 않는다', (WidgetTester tester) async {
    final subscriptions = List<Map<String, dynamic>>.generate(
      6,
      (index) => subscriptionJson(
        id: 'sub_exposure_$index',
        name: '노출경계$index',
        daysUntilDue: 6 + index,
        amount: 9000 + index.toDouble() * 1000,
      ),
    );

    await pumpApp(tester, subscriptions: subscriptions);
    expect(find.byType(MascotFace), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pump(const Duration(milliseconds: 350));

    final drawerFinder = find.byType(Drawer);
    expect(drawerFinder, findsOneWidget);
    expect(
      find.descendant(
        of: drawerFinder,
        matching: find.byType(MascotFace),
      ),
      findsNothing,
    );
    expect(find.byType(MascotFace), findsOneWidget);
  });

  testWidgets('모션 축소 모드에서는 캐릭터 루프 모션을 완화하고 반응만 유지한다',
      (WidgetTester tester) async {
    await pumpApp(
      tester,
      subscriptions: <Map<String, dynamic>>[
        subscriptionJson(
          id: 'sub_reduced_motion',
          name: '모션축소',
          daysUntilDue: 1,
          amount: 13000,
        ),
      ],
      reducedMotionOverride: true,
    );

    final mascotFinder = find.byType(AnimatedMascotFace);
    expect(mascotFinder, findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
    final blinkLidFinder = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_BlinkLid',
    );
    expect(blinkLidFinder, findsNothing);

    await tester.tap(mascotFinder);
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('mascot-state-reacting')),
      findsOneWidget,
    );
    await tester.pump(const Duration(milliseconds: 380));
    expect(
      find.byKey(const ValueKey<String>('mascot-state-hint-urgent')),
      findsOneWidget,
    );
  });

  testWidgets('저프레임 환경 시뮬레이션에서도 홈 핵심 동선에서 예외가 없다', (WidgetTester tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(360, 800);

    final subscriptions = List<Map<String, dynamic>>.generate(
      18,
      (index) => subscriptionJson(
        id: 'sub_low_end_$index',
        name: '저사양테스트$index',
        daysUntilDue: 2 + index,
        amount: 3500 + index.toDouble() * 700,
      ),
    );
    await pumpApp(tester, subscriptions: subscriptions);

    final listFinder = find.byType(ListView);
    final mascotFinder = find.byType(AnimatedMascotFace);
    expect(listFinder, findsOneWidget);
    expect(mascotFinder, findsOneWidget);

    await tester.tap(mascotFinder);
    await tester.pump(const Duration(milliseconds: 42));

    for (var i = 0; i < 9; i++) {
      await tester.drag(listFinder, const Offset(0, -90));
      await tester.pump(const Duration(milliseconds: 42));
    }
    for (var i = 0; i < 9; i++) {
      await tester.drag(listFinder, const Offset(0, 90));
      await tester.pump(const Duration(milliseconds: 42));
    }

    await tester.pump(const Duration(milliseconds: 420));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MascotFace), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('핵심 모바일 뷰포트와 텍스트 스케일 1.5에서 레이아웃 예외가 없다',
      (WidgetTester tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    final viewports = <Size>[
      const Size(360, 800),
      const Size(390, 844),
      const Size(412, 915),
    ];

    for (final viewport in viewports) {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = viewport;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;

      await pumpApp(
        tester,
        subscriptions: <Map<String, dynamic>>[
          subscriptionJson(
            id: 'sub_viewport',
            name: '테스트구독',
            daysUntilDue: 2,
            amount: 15000,
          ),
        ],
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(MascotFace), findsOneWidget);
      expect(find.textContaining('7일 내 결제'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
