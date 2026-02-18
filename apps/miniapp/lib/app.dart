import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miniapp/core/models/subscription_item.dart';
import 'package:miniapp/core/services/alert_evaluator.dart';
import 'package:miniapp/core/services/local_storage_repository.dart';
import 'package:miniapp/core/services/metrics_calculator.dart';
import 'package:miniapp/core/theme/app_palette.dart';
import 'package:miniapp/core/theme/app_theme.dart';
import 'package:miniapp/features/alerts/alerts_drawer.dart';
import 'package:miniapp/features/home/home_page.dart';
import 'package:miniapp/features/subscriptions/subscription_form_sheet.dart';

class MiniAppRoot extends StatelessWidget {
  const MiniAppRoot({
    super.key,
    this.nowProvider = DateTime.now,
    this.reducedMotionOverride,
  });

  final DateTime Function() nowProvider;
  final bool? reducedMotionOverride;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모아멍',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      builder: (context, child) {
        if (reducedMotionOverride == null || child == null) {
          return child ?? const SizedBox.shrink();
        }
        final mediaQuery = MediaQuery.maybeOf(context);
        if (mediaQuery == null) {
          return child;
        }
        return MediaQuery(
          data: mediaQuery.copyWith(disableAnimations: reducedMotionOverride),
          child: child,
        );
      },
      home: _HomeShell(nowProvider: nowProvider),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell({
    required this.nowProvider,
  });

  final DateTime Function() nowProvider;

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  final LocalStorageRepository _repository = LocalStorageRepository();
  final MetricsCalculator _metricsCalculator = MetricsCalculator();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _alertsButtonFocusNode = FocusNode(
    debugLabel: 'topActionAlerts',
  );
  final FocusNode _addButtonFocusNode = FocusNode(
    debugLabel: 'topActionAdd',
  );

  late final AlertEvaluator _alertEvaluator;

  bool _isLoading = true;
  bool _recoveredFromCorruption = false;
  List<SubscriptionItem> _subscriptions = <SubscriptionItem>[];

  @override
  void initState() {
    super.initState();
    _alertEvaluator = AlertEvaluator(_metricsCalculator);
    unawaited(_loadState());
  }

  @override
  void dispose() {
    _alertsButtonFocusNode.dispose();
    _addButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final now = widget.nowProvider();
    final snapshot = _metricsCalculator.buildSnapshot(
      subscriptions: _subscriptions,
      now: now,
    );
    final alerts = _alertEvaluator.buildAlerts(
      subscriptions: _subscriptions,
      now: now,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          _TopActionButton(
            icon: Icons.notifications_none_rounded,
            tooltip: '알림 열기',
            buttonKey: const ValueKey<String>('top-action-alerts'),
            focusNode: _alertsButtonFocusNode,
            focusOrder: 1,
            onPressed: _openAlertsDrawer,
          ),
          _TopActionButton(
            icon: Icons.add_circle_outline_rounded,
            tooltip: '구독 추가',
            buttonKey: const ValueKey<String>('top-action-add'),
            focusNode: _addButtonFocusNode,
            focusOrder: 2,
            onPressed: _openSubscriptionForm,
          ),
          const SizedBox(width: 8),
        ],
      ),
      endDrawer: AlertsDrawer(
        alerts: alerts,
        onAddSubscription: _openSubscriptionForm,
      ),
      body: HomePage(
        snapshot: snapshot,
        alerts: alerts,
        subscriptions: _subscriptions,
        now: now,
        nowProvider: widget.nowProvider,
        recoveredFromCorruption: _recoveredFromCorruption,
        onAddSubscription: _openSubscriptionForm,
        onEditSubscription: _editSubscription,
        onDeleteSubscription: _deleteSubscription,
      ),
    );
  }

  Future<void> _loadState() async {
    final loaded = await _repository.loadState();
    if (!mounted) {
      return;
    }
    setState(() {
      _subscriptions = loaded.subscriptions;
      _recoveredFromCorruption = loaded.recoveredFromCorruption;
      _isLoading = false;
    });

    if (loaded.recoveredFromCorruption) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackBar('저장 데이터 복원 중 오류가 있어 기본 상태로 복구했어요.');
      });
    }
  }

  Future<void> _saveState() async {
    await _repository.saveState(
      subscriptions: _subscriptions,
    );
  }

  void _openAlertsDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _openSubscriptionForm() {
    unawaited(_openSubscriptionFormWithItem(null));
  }

  Future<void> _openSubscriptionFormWithItem(
    SubscriptionItem? initialItem,
  ) async {
    final created = await showModalBottomSheet<SubscriptionItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SubscriptionFormSheet(
            initialItem: initialItem,
          ),
        ),
      ),
    );
    if (created == null) {
      return;
    }

    setState(() {
      final next = <SubscriptionItem>[
        ..._subscriptions.where((item) => item.id != created.id),
        created,
      ];
      next.sort(
        (left, right) => left.nextBillingDate.compareTo(right.nextBillingDate),
      );
      _subscriptions = next;
      _recoveredFromCorruption = false;
    });

    unawaited(_saveState());
    _showSnackBar(initialItem == null ? '구독이 추가되었어요.' : '구독이 수정되었어요.');
  }

  void _editSubscription(SubscriptionItem item) {
    unawaited(_openSubscriptionFormWithItem(item));
  }

  void _deleteSubscription(String subscriptionId) {
    setState(() {
      _subscriptions = _subscriptions
          .where((item) => item.id != subscriptionId)
          .toList(growable: false);
    });

    unawaited(_saveState());
    _showSnackBar('구독 항목이 삭제되었어요.');
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.focusOrder,
    this.buttonKey,
    this.focusNode,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final double focusOrder;
  final Key? buttonKey;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(focusOrder),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppPalette.white,
            border: Border.all(color: AppPalette.line),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppPalette.shadow.withValues(alpha: 0.12),
                blurRadius: 14,
                spreadRadius: -8,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: IconButton(
            key: buttonKey,
            focusNode: focusNode,
            onPressed: onPressed,
            tooltip: tooltip,
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}
