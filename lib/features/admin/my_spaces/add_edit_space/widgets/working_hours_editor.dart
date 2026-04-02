import 'package:flutter/material.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/week_day.dart';
import '../domain/entities/working_hours_entity.dart';

class WorkingHoursEditor extends StatelessWidget {
  final List<WorkingHoursEntity> hours;
  final void Function(WeekDay day, bool enabled) onDayEnabled;
  final void Function(WeekDay day, bool closed) onClosed;
  final void Function(WeekDay day, String open, String close) onTimeChanged;
  final String? errorText;

  const WorkingHoursEditor({
    super.key,
    required this.hours,
    required this.onDayEnabled,
    required this.onClosed,
    required this.onTimeChanged,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Working Hours', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w700)),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Text(errorText!, style: AdminText.label12(color: AdminColors.danger, w: FontWeight.w700)),
          ],
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: WeekDay.values.map((d) {
              final exists = hours.any((x) => x.day == d);
              final active = exists && !(hours.firstWhere((x) => x.day == d).closed);
              return _DayChip(
                label: d.name.toUpperCase(),
                active: active,
                onTap: () => onDayEnabled(d, !active),
              );
            }).toList(growable: false),
          ),

          const SizedBox(height: 12),
          ...hours.map((h) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _Row(
                day: h.day.name.toUpperCase(),
                open: h.open,
                close: h.close,
                closed: h.closed,
                onClosed: (v) => onClosed(h.day, v),
                onPickOpen: () async {
                  final picked = await showTimePicker(context: context, initialTime: _toTime(h.open));
                  if (picked == null) return;
                  onTimeChanged(h.day, _toHHmm(picked), h.close);
                },
                onPickClose: () async {
                  final picked = await showTimePicker(context: context, initialTime: _toTime(h.close));
                  if (picked == null) return;
                  onTimeChanged(h.day, h.open, _toHHmm(picked));
                },
              ),
            );
          }).toList(growable: false),
        ],
      ),
    );
  }

  static TimeOfDay _toTime(String hhmm) {
    final parts = hhmm.split(':');
    final h = int.tryParse(parts.isNotEmpty ? parts[0] : '8') ?? 8;
    final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
    return TimeOfDay(hour: h, minute: m);
  }

  static String _toHHmm(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _DayChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = active ? AdminColors.primaryBlue.withOpacity(0.15) : Colors.transparent;
    final br = active ? AdminColors.primaryBlue.withOpacity(0.15) : AdminColors.black15;
    final fg = active ? AdminColors.primaryBlue : AdminColors.black75;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: br, width: 1),
        ),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: fg, w: FontWeight.w700)),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String day;
  final String open;
  final String close;
  final bool closed;
  final ValueChanged<bool> onClosed;
  final VoidCallback onPickOpen;
  final VoidCallback onPickClose;

  const _Row({
    required this.day,
    required this.open,
    required this.close,
    required this.closed,
    required this.onClosed,
    required this.onPickOpen,
    required this.onPickClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.black02,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.black10, width: 1),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(width: 48, child: Text(day, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.label12(color: AdminColors.black40, w: FontWeight.w700))),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: closed ? null : onPickOpen,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: AdminColors.bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AdminColors.black15, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(open, style: AdminText.body14(w: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: closed ? null : onPickClose,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: AdminColors.bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AdminColors.black15, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(close, style: AdminText.body14(w: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text('Closed', style: AdminText.label12(color: AdminColors.black40, w: FontWeight.w700)),
              Switch(value: closed, onChanged: onClosed, activeColor: AdminColors.primaryBlue),
            ],
          ),
        ],
      ),
    );
  }
}


