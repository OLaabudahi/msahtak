import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../theme/app_colors.dart';
import '../../search_results/widgets/space_result_card.dart';
import '../../space_details/data/repos/space_details_repo_firebase.dart';
import '../../space_details/domain/usecases/get_favorites_usecase.dart';
import '../../space_details/view/space_details_page.dart';
import '../bloc/saved_spaces_bloc.dart';
import '../bloc/saved_spaces_event.dart';
import '../bloc/saved_spaces_state.dart';
import '../data/repos/saved_spaces_repo_firebase.dart';
import '../data/sources/saved_spaces_firebase_source.dart';
import '../domain/usecases/get_saved_spaces_usecase.dart';

class SavedSpacesPage extends StatelessWidget {
  const SavedSpacesPage({super.key});

  static Widget withBloc() {
    final source = SavedSpacesFirebaseSource();
    final repo = SavedSpacesRepoFirebase(source);
    final favoritesUseCase = GetFavoritesUseCase(SpaceDetailsRepoFirebase());

    return BlocProvider(
      create: (_) => SavedSpacesBloc(
        getSavedSpacesUseCase: GetSavedSpacesUseCase(
          repo: repo,
          getFavoritesUseCase: favoritesUseCase,
        ),
      )..add(const SavedSpacesStarted()),
      child: const SavedSpacesPage(),
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
          icon: const Icon(Icons.arrow_back, color: AppColors.text, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.t('savedSpaces'),
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<SavedSpacesBloc, SavedSpacesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          if (state.spaces.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline, size: 64, color: AppColors.secondary),
                  const SizedBox(height: 16),
                  Text(
                    context.t('savedSpaces'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.t('noSavedSpaces'),
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: state.spaces.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final space = state.spaces[i];
              return SpaceResultCard(
                space: space,
                cardColor: Colors.white,
                onView: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SpaceDetailsPage.withBloc(spaceId: space.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
