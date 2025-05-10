import 'package:expense_management_system/feature/schedule/model/event_rule.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecurrenceRuleSelector extends StatefulWidget {
  final EventRule value;
  final ValueChanged<EventRule> onChanged;

  const RecurrenceRuleSelector({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RecurrenceRuleSelector> createState() => _RecurrenceRuleSelectorState();
}

class _RecurrenceRuleSelectorState extends State<RecurrenceRuleSelector> {
  late EventRule _rule;
  bool _showAdvancedOptions = false;

  @override
  void initState() {
    super.initState();
    _rule = widget.value;
  }

  @override
  void didUpdateWidget(RecurrenceRuleSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _rule = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   'Recurrence',
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // const SizedBox(height: 12),
        _buildFrequencySelector(),
        if (_rule.frequency != EventFrequency.once) ...[
          const SizedBox(height: 12),
          _buildIntervalSelector(),
          const SizedBox(height: 12),
          _buildEndOptions(),
          if (_showAdvancedOptions) ...[
            const SizedBox(height: 16),
            _buildAdvancedOptions(),
          ],
          const SizedBox(height: 12),
          TextButton.icon(
            icon: Icon(_showAdvancedOptions
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down),
            label: Text(_showAdvancedOptions
                ? 'Hide advanced options'
                : 'Show advanced options'),
            onPressed: () {
              setState(() => _showAdvancedOptions = !_showAdvancedOptions);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildFrequencySelector() {
    return FormField<EventFrequency>(
      initialValue: _rule.frequency,
      builder: (FormFieldState<EventFrequency> field) {
        return InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Repeats',
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EventFrequency>(
              isExpanded: true,
              value: _rule.frequency,
              onChanged: (value) {
                if (value != null) {
                  field.didChange(value);
                  final newRule = _rule.copyWith(frequency: value);
                  setState(() {
                    _rule = newRule;
                    if (value == EventFrequency.once) {
                      _showAdvancedOptions = false;
                    }
                  });
                  widget.onChanged(newRule);
                }
              },
              items: EventFrequency.values.map((freq) {
                return DropdownMenuItem<EventFrequency>(
                  value: freq,
                  child: Text(_getFrequencyLabel(freq)),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntervalSelector() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: _rule.interval.toString(),
            decoration: InputDecoration(
              labelText: 'Every',
              labelStyle: const TextStyle(fontSize: 16),
              border: const OutlineInputBorder(),
              suffix: Text(_getIntervalSuffix(_rule.frequency)),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final interval = int.tryParse(value) ?? 1;
              if (interval > 0) {
                final newRule = _rule.copyWith(interval: interval);
                setState(() => _rule = newRule);
                widget.onChanged(newRule);
              }
            },
          ),
        ),
      ],
    );
  }

  // Widget _buildEndOptions() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text('Ends', style: TextStyle(fontSize: 16)),
  //       const SizedBox(height: 8),
  //       RadioListTile<bool>(
  //         title: const Text('Never'),
  //         value: false,
  //         groupValue: _rule.endDate != null || _rule.maxOccurrences != null,
  //         onChanged: (value) {
  //           if (value == false) {
  //             final newRule =
  //                 _rule.copyWith(endDate: null, maxOccurrences: null);
  //             setState(() => _rule = newRule);
  //             widget.onChanged(newRule);
  //           }
  //         },
  //         contentPadding: EdgeInsets.zero,
  //       ),
  //       RadioListTile<bool>(
  //         title: const Text('On date'),
  //         value: _rule.endDate != null,
  //         groupValue: _rule.endDate != null,
  //         onChanged: (value) async {
  //           if (value == true) {
  //             final date = await showDatePicker(
  //               context: context,
  //               initialDate: _rule.endDate ??
  //                   DateTime.now().add(const Duration(days: 30)),
  //               firstDate: DateTime.now(),
  //               lastDate: DateTime(2030),
  //             );
  //             if (date != null) {
  //               final newRule =
  //                   _rule.copyWith(endDate: date, maxOccurrences: null);
  //               setState(() => _rule = newRule);
  //               widget.onChanged(newRule);
  //             }
  //           }
  //         },
  //         contentPadding: EdgeInsets.zero,
  //         secondary: _rule.endDate != null
  //             ? Text(DateFormat('MMM d, yyyy').format(_rule.endDate!))
  //             : null,
  //       ),
  //       RadioListTile<bool>(
  //         title: Row(
  //           children: [
  //             const Text('After '),
  //             SizedBox(
  //               width: 50,
  //               child: TextFormField(
  //                 initialValue: _rule.maxOccurrences?.toString() ?? '10',
  //                 keyboardType: TextInputType.number,
  //                 decoration: const InputDecoration(
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 8),
  //                 ),
  //                 enabled: _rule.maxOccurrences != null,
  //                 onChanged: (value) {
  //                   final occurrences = int.tryParse(value);
  //                   if (occurrences != null && occurrences > 0) {
  //                     final newRule = _rule.copyWith(
  //                         maxOccurrences: occurrences, endDate: null);
  //                     setState(() => _rule = newRule);
  //                     widget.onChanged(newRule);
  //                   }
  //                 },
  //               ),
  //             ),
  //             const Text(' occurrences'),
  //           ],
  //         ),
  //         value: _rule.maxOccurrences != null,
  //         groupValue: _rule.maxOccurrences != null,
  //         onChanged: (value) {
  //           if (value == true) {
  //             final newRule = _rule.copyWith(maxOccurrences: 10, endDate: null);
  //             setState(() => _rule = newRule);
  //             widget.onChanged(newRule);
  //           }
  //         },
  //         contentPadding: EdgeInsets.zero,
  //       ),
  //     ],
  //   );
  // }

// Cập nhật phương thức _buildEndOptions()
  Widget _buildEndOptions() {
    // Xác định loại kết thúc hiện tại
    EndType currentEndType = EndType.never;
    if (_rule.endDate != null) {
      currentEndType = EndType.onDate;
    } else if (_rule.maxOccurrences != null) {
      currentEndType = EndType.afterOccurrences;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ends', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        RadioListTile<EndType>(
          title: const Text('Never'),
          value: EndType.never,
          groupValue: currentEndType,
          onChanged: (value) {
            if (value != null) {
              final newRule =
                  _rule.copyWith(endDate: null, maxOccurrences: null);
              setState(() => _rule = newRule);
              widget.onChanged(newRule);
            }
          },
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<EndType>(
          title: const Text('On date'),
          value: EndType.onDate,
          groupValue: currentEndType,
          onChanged: (value) async {
            if (value == EndType.onDate) {
              final date = await showDatePicker(
                context: context,
                initialDate: _rule.endDate ??
                    DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                final newRule =
                    _rule.copyWith(endDate: date, maxOccurrences: null);
                setState(() => _rule = newRule);
                widget.onChanged(newRule);
              }
            }
          },
          onFocusChange: (value) {
            if (value == EndType.onDate) {
              final date = DateTime.now().add(const Duration(days: 30));
              final newRule =
                  _rule.copyWith(endDate: date, maxOccurrences: null);
              setState(() => _rule = newRule);
              widget.onChanged(newRule);
            }
          },
          contentPadding: EdgeInsets.zero,
          secondary: _rule.endDate != null
              ? Text(DateFormat('MMM d, yyyy').format(_rule.endDate!))
              : null,
        ),
        RadioListTile<EndType>(
          title: Row(
            children: [
              const Text('After '),
              SizedBox(
                width: 50,
                child: TextFormField(
                  initialValue: _rule.maxOccurrences?.toString() ?? '10',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  enabled: currentEndType == EndType.afterOccurrences,
                  onChanged: (value) {
                    final occurrences = int.tryParse(value);
                    if (occurrences != null && occurrences > 0) {
                      final newRule = _rule.copyWith(
                          maxOccurrences: occurrences, endDate: null);
                      setState(() => _rule = newRule);
                      widget.onChanged(newRule);
                    }
                  },
                ),
              ),
              const Text(' occurrences'),
            ],
          ),
          value: EndType.afterOccurrences,
          groupValue: currentEndType,
          onChanged: (value) {
            if (value == EndType.afterOccurrences) {
              final newRule = _rule.copyWith(maxOccurrences: 10, endDate: null);
              setState(() => _rule = newRule);
              widget.onChanged(newRule);
            }
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildAdvancedOptions() {
    switch (_rule.frequency) {
      case EventFrequency.weekly:
        return _buildWeekdaySelector();
      case EventFrequency.monthly:
        return _buildMonthDaySelector();
      case EventFrequency.yearly:
        return _buildMonthSelector();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWeekdaySelector() {
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final selectedDays = _rule.byDayOfWeek?.toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Repeat on', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: daysOfWeek.map((day) {
            final isSelected = selectedDays.contains(day);
            return FilterChip(
              label: Text(day.substring(0, 3)),
              selected: isSelected,
              onSelected: (selected) {
                final newSelection = List<String>.from(selectedDays);
                if (selected) {
                  if (!newSelection.contains(day)) newSelection.add(day);
                } else {
                  newSelection.remove(day);
                }
                final newRule = _rule.copyWith(byDayOfWeek: newSelection);
                setState(() => _rule = newRule);
                widget.onChanged(newRule);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthDaySelector() {
    final selectedDays = _rule.byMonthDay?.toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Repeat on day', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: List.generate(31, (i) => i + 1).map((day) {
            final isSelected = selectedDays.contains(day);
            return FilterChip(
              label: Text('$day'),
              selected: isSelected,
              onSelected: (selected) {
                final newSelection = List<int>.from(selectedDays);
                if (selected) {
                  if (!newSelection.contains(day)) newSelection.add(day);
                } else {
                  newSelection.remove(day);
                }
                final newRule = _rule.copyWith(byMonthDay: newSelection);
                setState(() => _rule = newRule);
                widget.onChanged(newRule);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final selectedMonths = _rule.byMonth?.toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Repeat in months', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: List.generate(12, (i) => i + 1).map((monthNum) {
            final isSelected = selectedMonths.contains(monthNum);
            return FilterChip(
              label: Text(monthNames[monthNum - 1].substring(0, 3)),
              selected: isSelected,
              onSelected: (selected) {
                final newSelection = List<int>.from(selectedMonths);
                if (selected) {
                  if (!newSelection.contains(monthNum))
                    newSelection.add(monthNum);
                } else {
                  newSelection.remove(monthNum);
                }
                final newRule = _rule.copyWith(byMonth: newSelection);
                setState(() => _rule = newRule);
                widget.onChanged(newRule);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getFrequencyLabel(EventFrequency frequency) {
    switch (frequency) {
      case EventFrequency.once:
        return 'Once (No repetition)';
      case EventFrequency.daily:
        return 'Daily';
      case EventFrequency.weekly:
        return 'Weekly';
      case EventFrequency.monthly:
        return 'Monthly';
      case EventFrequency.yearly:
        return 'Yearly';
      default:
        return 'Unknown';
    }
  }

  String _getIntervalSuffix(EventFrequency frequency) {
    switch (frequency) {
      case EventFrequency.daily:
        return _rule.interval > 1 ? 'days' : 'day';
      case EventFrequency.weekly:
        return _rule.interval > 1 ? 'weeks' : 'week';
      case EventFrequency.monthly:
        return _rule.interval > 1 ? 'months' : 'month';
      case EventFrequency.yearly:
        return _rule.interval > 1 ? 'years' : 'year';
      default:
        return '';
    }
  }
}
