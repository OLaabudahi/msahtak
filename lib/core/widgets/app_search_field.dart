import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AppSearchField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> suggestions;
  final Function(String) onChanged;
  final Function(String) onSuggestionSelected;
  final VoidCallback? onFilterTap;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.onChanged,
    required this.onSuggestionSelected,
    this.onFilterTap,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!mounted) return;
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search workspace',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: widget.onChanged,
              ),
            ),
            if (widget.onFilterTap != null) ...[
              const SizedBox(width: 10),
              InkWell(
                onTap: widget.onFilterTap,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColors.btnPrimary,
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ),
            ],
          ],
        ),

        // Dropdown
        if (_isFocused &&
            widget.controller.text.trim().isNotEmpty &&
            widget.suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.suggestions.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final s = widget.suggestions[i];
                    return ListTile(
                      dense: true,
                      title: Text(s),
                      onTap: () {
                        widget.controller.text = s;
                        widget.controller.selection =
                            TextSelection.collapsed(offset: s.length);
                        FocusScope.of(context).unfocus();
                        widget.onSuggestionSelected(s);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}


