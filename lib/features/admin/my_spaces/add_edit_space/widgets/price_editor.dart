import 'package:Msahtak/features/admin/my_spaces/add_edit_space/domain/entities/price_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/i18n/app_i18n.dart';
import '../../../_shared/admin_ui.dart';
import '../domain/entities/price_unit.dart';

class PriceEditor extends StatefulWidget {
  final List<PriceEntity> prices;
  final Function(String value, PriceUnit unit) onAdd;
  final Function(int index) onRemove;

  const PriceEditor({
    super.key,
    required this.prices,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<PriceEditor> createState() => _PriceEditorState();
}

class _PriceEditorState extends State<PriceEditor> {
  final _controller = TextEditingController();
  PriceUnit _unit = PriceUnit.day;

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;

    widget.onAdd(value, _unit);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Additional Prices",
              style: AdminText.body14(
                  color: AdminColors.black75, w: FontWeight.w700)),

          const SizedBox(height: 10),

          /// 🔥 list
          ...List.generate(widget.prices.length, (i) {
            final p = widget.prices[i];

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${p.value} / ${p.unit.name}",
                      style: AdminText.body14(),
                    ),
                  ),
                  IconButton(
                    onPressed: () => widget.onRemove(i),
                    icon: const Icon(Icons.delete, size: 18),
                  )
                ],
              ),
            );
          }),

          const SizedBox(height: 10),

          /// 🔥 add row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Price",
                  ),
                ),
              ),
              const SizedBox(width: 8),

              DropdownButton<PriceUnit>(
                value: _unit,
                items: const [
                  DropdownMenuItem(value: PriceUnit.day, child: Text("Day")),
                  DropdownMenuItem(value: PriceUnit.week, child: Text("Week")),
                  DropdownMenuItem(
                      value: PriceUnit.month, child: Text("Month")),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _unit = v);
                },
              ),

              const SizedBox(width: 8),

              IconButton(
                onPressed: _add,
                icon: const Icon(Icons.add),
              )
            ],
          ),
        ],
      ),
    );
  }
}


