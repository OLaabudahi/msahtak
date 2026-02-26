import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onAiTap,
    this.onFilterTap,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchTap,
    this.hintText = 'Search',
    this.width,
    this.height = 58,
    this.fieldWidth = 295.958,
    this.slotWidth = 106.5,
    this.aiButtonWidth = 97,
    this.aiButtonHeight = 38,
    this.aiRightInset = 0,
    this.aiShadow,
    this.showAiButton = true,
    this.showFilterButton = false,

    // Dropdown
    this.suggestions = const [],
    this.onSuggestionSelected,
    this.maxSuggestions = 6,
  });

  final TextEditingController controller;

  /// AI (اختياري)
  final VoidCallback? onAiTap;
  final bool showAiButton;

  /// فلتر (اختياري) — إذا بدك نفس زر الفلاتر تبع SearchResults
  final VoidCallback? onFilterTap;
  final bool showFilterButton;

  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchTap;

  final String hintText;

  /// عرض/ارتفاع (الـwidth إذا null بياخد عرض المكان)
  final double? width;
  final double height;

  /// نفس قياسات SVG تبعتك
  final double fieldWidth;
  final double slotWidth;
  final double aiButtonWidth;
  final double aiButtonHeight;
  final double aiRightInset;

  final BoxShadow? aiShadow;

  /// Dropdown suggestions
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionSelected;
  final int maxSuggestions;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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
    final topInset = (widget.height - widget.aiButtonHeight) / 2;

    final visibleSuggestions = widget.suggestions.length > widget.maxSuggestions
        ? widget.suggestions.take(widget.maxSuggestions).toList()
        : widget.suggestions;

    final shouldShowDropdown =
        _isFocused &&
            widget.controller.text.trim().isNotEmpty &&
            visibleSuggestions.isNotEmpty &&
            widget.onSuggestionSelected != null;

    return SizedBox(
      width: widget.width ?? double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: Stack(
              children: [
                // 1) حقل البحث الرمادي
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: widget.fieldWidth,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      focusNode: _focusNode,
                      controller: widget.controller,
                      onChanged: widget.onSearchChanged,
                      onSubmitted: widget.onSearchSubmitted,
                      onTap: widget.onSearchTap,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textMuted,
                          size: 22,
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),

                // زر فلتر (اختياري) على يمين الحقل (زي SearchResults)
                if (widget.showFilterButton && widget.onFilterTap != null)
                  Positioned(
                    left: widget.fieldWidth + 10,
                    top: (widget.height - 44) / 2,
                    child: InkWell(
                      onTap: widget.onFilterTap,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFFF2A23A),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ),
                  ),

                // 2) الخلفية البيضاء (slot) تحت زر AI
                if (widget.showAiButton)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: widget.slotWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(widget.height / 2),
                      ),
                    ),
                  ),

                // 3) زر AI
                if (widget.showAiButton && widget.onAiTap != null)
                  Positioned(
                    right: widget.aiRightInset,
                    top: topInset,
                    child: InkWell(
                      onTap: widget.onAiTap,
                      borderRadius: BorderRadius.circular(widget.aiButtonHeight / 2),
                      child: Container(
                        width: widget.aiButtonWidth,
                        height: widget.aiButtonHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.aiButtonHeight / 2),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              AppColors.primary,
                              AppColors.amber,
                              AppColors.amber,
                              AppColors.dotInactive,
                            ],
                            stops: [0.0, 0.297, 0.467, 1.0],
                          ),
                          boxShadow: [
                            widget.aiShadow ??
                                BoxShadow(
                                  color: AppColors.shadowLight,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "AI Concierge",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Dropdown suggestions
          if (shouldShowDropdown)
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
                    itemCount: visibleSuggestions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final s = visibleSuggestions[i];
                      return ListTile(
                        dense: true,
                        title: Text(s, maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () {
                          widget.controller.text = s;
                          widget.controller.selection = TextSelection.collapsed(offset: s.length);
                          FocusScope.of(context).unfocus();
                          widget.onSuggestionSelected!(s);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}