import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../core/i18n/app_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../space_details/view/space_details_page.dart';
import '../bloc/offers_bloc.dart';
import '../bloc/offers_event.dart';
import '../bloc/offers_state.dart';
import '../data/repos/offers_repo_dummy.dart';
import '../data/sources/offers_firebase_source.dart';
import '../domain/usecases/get_offers_usecase.dart';
import '../domain/usecases/search_offers_usecase.dart';
import '../widgets/deal_card.dart';
import '../widgets/offers_search_bar.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  /// ط¥ظ†ط´ط§ط، ط§ظ„طµظپط­ط© ظ…ط¹ BLoC ط®ط§طµ ط¨ظ‡ط§
  static Widget withBloc() {
    final source = OffersFirebaseSource();
    final repo = OffersRepoDummy(source);
    return BlocProvider(
      create: (_) => OffersBloc(
        getOffersUseCase: GetOffersUseCase(repo),
        searchOffersUseCase: SearchOffersUseCase(repo),
      )..add(const OffersStarted()),
      child: const OffersPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _OffersView();
  }
}

class _OffersView extends StatefulWidget {
  const _OffersView();

  @override
  State<_OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<_OffersView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// ط§ظ„طھظ†ظ‚ظ„ ط¥ظ„ظ‰ طµظپط­ط© طھظپط§طµظٹظ„ ط§ظ„ظپط¶ط§ط، ط¹ظ†ط¯ ط§ظ„ط¶ط؛ط· ط¹ظ„ظ‰ Deal
  void _openSpaceDetails(String spaceId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpaceDetailsPage.withBloc(spaceId: spaceId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.t('offersPageTitle'),
          style: const TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<OffersBloc, OffersState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: OffersSearchBar(
                  controller: _searchController,
                  onChanged: (q) => context
                      .read<OffersBloc>()
                      .add(OffersSearchChanged(q)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Text(
                  context.t('offersTopDeals'),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              if (state.isLoading)
                const Expanded(
                    child: Center(
                        child: CircularProgressIndicator()))
              else if (state.filteredOffers.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      context.t('offersEmpty'),
                      style: const TextStyle(
                          fontSize: 14, color: Colors.grey),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    itemCount: state.filteredOffers.length,
                    itemBuilder: (context, index) {
                      final offer = state.filteredOffers[index];
                      return DealCard(
                        offer: offer,
                        onDealTap: () {
                          context
                              .read<OffersBloc>()
                              .add(OfferDealPressed(offer.id));
                          _openSpaceDetails(offer.id);
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}


