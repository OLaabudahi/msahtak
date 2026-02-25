import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_results_bloc.dart';
import '../bloc/search_results_event.dart';
import '../bloc/search_results_state.dart';
import '../data/repos/search_results_repo_impl.dart';
import '../data/sources/search_results_remote_source.dart';
import '../domain/usecases/get_preferred_filter_chips_usecase.dart';
import '../domain/usecases/search_spaces_usecase.dart';
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
    final repo = SearchResultsRepoImpl(remote: const SearchResultsRemoteSource());
    return BlocProvider(
      create: (_) => SearchResultsBloc(
        searchSpacesUseCase: SearchSpacesUseCase(repo),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openFilters(BuildContext context) {
    // API-ready navigation:
    // لاحقًا: ننتقل لشاشة الفلاتر ونرجع Map<String, dynamic> selectedFilters
    // ثم: context.read<SearchResultsBloc>().add(SearchApplyFilters(filters));
    // حاليا: Dummy apply
    context.read<SearchResultsBloc>().add(const SearchApplyFilters({
      'priceMax': 40,
      'quiet': true,
      'wifi': 'fast',
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.originTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Search workspace',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (v) => context.read<SearchResultsBloc>().add(SearchQueryChanged(v)),
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
                          color: const Color(0xFFF2A23A),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // (2) الهنت محذوف نهائيًا ✅

              if (state.hasAppliedFilters && state.preferredChips.isNotEmpty)
                PreferredChipsRow(
                  chips: state.preferredChips,
                  onRemove: (id) => context.read<SearchResultsBloc>().add(SearchRemovePreferredChip(id)),
                ),

              const SizedBox(height: 10),

              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.results.isEmpty
                    ? const Center(child: Text('Try adjusting filters to see more spaces'))
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (_, i) => SpaceResultCard(space: state.results[i]),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: state.results.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}