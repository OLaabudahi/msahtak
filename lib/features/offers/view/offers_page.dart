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

  /// إنشاء الصفحة مع BLoC خاص بها
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
  String? _selectedSpaceId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// التنقل إلى صفحة تفاصيل الفضاء عند الضغط على Deal
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
          final available = state.filteredOffers;
          final matchingSpaceOptions = available
              .map((o) => MapEntry(o.id, o.name))
              .toSet()
              .toList(growable: false);
          final displayOffers = _selectedSpaceId == null
              ? available
              : available.where((o) => o.id == _selectedSpaceId).toList(growable: false);

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String?>(
                  value: _selectedSpaceId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    labelText: context.t('offersEligibleSpacesLabel'),
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(context.t('offersAllEligibleSpaces')),
                    ),
                    ...matchingSpaceOptions.map(
                      (e) => DropdownMenuItem<String?>(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedSpaceId = v),
                ),
              ),
              const SizedBox(height: 10),
              if (state.isLoading)
                const Expanded(
                    child: Center(
                        child: CircularProgressIndicator()))
              else if (displayOffers.isEmpty)
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
                    itemCount: displayOffers.length,
                    itemBuilder: (context, index) {
                      final offer = displayOffers[index];
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
