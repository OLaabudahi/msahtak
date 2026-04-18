import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../theme/app_colors.dart';
import '../../space_details/view/space_details_page.dart';
import '../bloc/search_results_bloc.dart';
import '../bloc/search_results_event.dart';
import '../bloc/search_results_state.dart';
import '../data/repos/search_results_repo_firebase.dart';
import '../data/sources/search_results_remote_source.dart';
import '../domain/usecases/get_preferred_filter_chips_usecase.dart';
import '../domain/usecases/filter_spaces_usecase.dart';
import '../domain/usecases/search_spaces_usecase.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/preferred_chips_row.dart';
import '../widgets/space_result_card.dart';

class SearchResultsPage extends StatefulWidget {
  final String originKey;
  final String originTitle;

  const SearchResultsPage({
    super.key,
    required this.originKey,
    required this.originTitle,
  });

  static Widget withBloc({
    required String originKey,
    required String originTitle,
  }) {
    final source = SearchResultsFirebaseSource();
    final repo = SearchResultsRepoFirebase(source: source);

    return BlocProvider(
      create: (_) => SearchResultsBloc(
        searchSpacesUseCase: SearchSpacesUseCase(repo, const FilterSpacesUseCase()),
        getPreferredFilterChipsUseCase: GetPreferredFilterChipsUseCase(repo),
      )..add(SearchResultsStarted(originKey: originKey, originTitle: originTitle)),
      child: SearchResultsPage(originKey: originKey, originTitle: originTitle),
    );
  }

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _controller = TextEditingController();
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
    _controller.dispose();
    super.dispose();
  }

  void _openFilters(BuildContext context) {
    final bloc = context.read<SearchResultsBloc>();
    final state = bloc.state;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterBottomSheet(
        initialFilters: state.selectedFilters,
        onApply: (filters) {
          bloc.add(SearchApplyFilters(filters));
        },
        onReset: () {
          bloc.add(const SearchResetFilters());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.switchThumb,
        title:  Text(widget.originTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                const SizedBox(height: 12),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Search workspace',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onChanged: (v) =>
                              context.read<SearchResultsBloc>().add(SearchQueryChanged(v)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => _openFilters(context),
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
                  ),
                ),

                
                if (_isFocused &&
                    state.query.trim().isNotEmpty &&
                    state.suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(14),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.suggestions.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final s = state.suggestions[i];
                            return ListTile(
                              dense: true,
                              title: Text(s,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              onTap: () {
                                _controller.text = s;
                                _controller.selection =
                                    TextSelection.collapsed(offset: s.length);
                                FocusScope.of(context).unfocus();
                                context
                                    .read<SearchResultsBloc>()
                                    .add(SearchSuggestionSelected(s));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                
                if (state.hasAppliedFilters && state.preferredChips.isNotEmpty)
                  PreferredChipsRow(
                    chips: state.preferredChips,
                    onRemove: (id) => context
                        .read<SearchResultsBloc>()
                        .add(SearchRemovePreferredChip(id)),
                  ),

                const SizedBox(height: 10),

                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.results.isEmpty
                          ? const Center(
                              child: Text(
                                  'Try adjusting filters to see more spaces'))
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemBuilder: (_, i) => SpaceResultCard(
                                space: state.results[i],
                                onView: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SpaceDetailsPage.withBloc(
                                        spaceId: state.results[i].id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemCount: state.results.length,
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
