import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miniapp/core/models/subscription_item.dart';
import 'package:miniapp/core/theme/app_palette.dart';

class SubscriptionFormSheet extends StatefulWidget {
  const SubscriptionFormSheet({
    super.key,
    this.initialItem,
  });

  final SubscriptionItem? initialItem;

  @override
  State<SubscriptionFormSheet> createState() => _SubscriptionFormSheetState();
}

class _SubscriptionFormSheetState extends State<SubscriptionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _customDaysController = TextEditingController(text: '30');

  BillingCycle _cycle = BillingCycle.monthly;
  DateTime _nextBillingDate = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    final initial = widget.initialItem;
    if (initial == null) {
      return;
    }
    _nameController.text = initial.name;
    _amountController.text = initial.amount.toStringAsFixed(0);
    _customDaysController.text = initial.cycleDays.toString();
    _cycle = initial.cycle;
    _nextBillingDate = initial.nextBillingDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _customDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 12 + bottomPadding),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.92),
                    AppPalette.yellowPale.withValues(alpha: 0.84),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                  color: AppPalette.line.withValues(alpha: 0.7),
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Align(
                          child: Container(
                            width: 42,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppPalette.line,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.initialItem == null ? '구독 추가' : '구독 수정',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        const Text('필수 입력: 서비스명, 요금, 결제 주기, 다음 결제일'),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: '서비스명',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '서비스명을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: '요금',
                            suffixText: '원',
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(
                              (value ?? '').replaceAll(',', '').trim(),
                            );
                            if (parsed == null || parsed <= 0) {
                              return '0보다 큰 금액을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<BillingCycle>(
                          initialValue: _cycle,
                          decoration: const InputDecoration(
                            labelText: '결제 주기',
                          ),
                          items: BillingCycle.values.map((cycle) {
                            return DropdownMenuItem(
                              value: cycle,
                              child: Text(_cycleText(cycle)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _cycle = value;
                            });
                          },
                        ),
                        if (_cycle == BillingCycle.customDays) ...<Widget>[
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _customDaysController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '사용자 주기(일)',
                            ),
                            validator: (value) {
                              final parsed = int.tryParse(value?.trim() ?? '');
                              if (parsed == null || parsed <= 0) {
                                return '1 이상의 주기를 입력해주세요.';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: Text('다음 결제일: ${_dateText(_nextBillingDate)}'),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _submit,
                            child: Text(
                              widget.initialItem == null ? '저장' : '수정 저장',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _nextBillingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (selected == null) {
      return;
    }
    setState(() {
      _nextBillingDate = selected;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = _parseAmount(_amountController.text.trim());
    final cycleDays = _cycle == BillingCycle.customDays
        ? int.parse(_customDaysController.text.trim())
        : 30;

    final item = SubscriptionItem(
      id: widget.initialItem?.id ??
          'sub_${DateTime.now().microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      amount: amount,
      cycle: _cycle,
      cycleDays: cycleDays,
      nextBillingDate: _nextBillingDate,
      status: widget.initialItem?.status ?? SubscriptionStatus.active,
      importance: widget.initialItem?.importance ?? Importance.normal,
      category: widget.initialItem?.category,
    );

    Navigator.of(context).pop(item);
  }

  String _cycleText(BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.monthly:
        return '월 결제';
      case BillingCycle.yearly:
        return '연 결제';
      case BillingCycle.weekly:
        return '주 결제';
      case BillingCycle.customDays:
        return '사용자 주기';
    }
  }

  String _dateText(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  double _parseAmount(String raw) {
    final normalized = raw.replaceAll(',', '').trim();
    return double.tryParse(normalized) ?? 0;
  }
}
