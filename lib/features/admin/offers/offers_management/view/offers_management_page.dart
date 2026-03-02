import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';
import '../../../_shared/admin_feedback_widgets.dart';

import '../bloc/offers_management_bloc.dart';
import '../bloc/offers_management_event.dart';
import '../bloc/offers_management_state.dart';
import '../data/repos/offers_repo_impl.dart';
import '../data/sources/offers_dummy_source.dart';
import '../domain/usecases/create_offer_usecase.dart';
import '../domain/usecases/get_offers_usecase.dart';
import '../domain/usecases/toggle_offer_usecase.dart';
import '../widgets/create_offer_sheet.dart';
import '../widgets/offer_card.dart';

class OffersManagementPage extends StatefulWidget {
  final bool fromHome;
  const OffersManagementPage({super.key, required this.fromHome});

  static Widget withBloc({bool fromHome = false}) {
    final source = OffersDummySource();
    final repo = OffersRepoImpl(source);
    return BlocProvider(
      create: (_) => OffersManagementBloc(
        getOffers: GetOffersUseCase(repo),
        toggleOffer: ToggleOfferUseCase(repo),
        createOffer: CreateOfferUseCase(repo),
      )..add(const OffersManagementStarted()),
      child: OffersManagementPage(fromHome: fromHome),
    );
  }

  @override
  State<OffersManagementPage> createState() => _OffersManagementPageState();
}

class _OffersManagementPageState extends State<OffersManagementPage> {
  bool _sheetOpen = false;

  Future<void> _openCreateSheet(BuildContext context) async {
    if (_sheetOpen) return;
    _sheetOpen = true;

    final bloc = context.read<OffersManagementBloc>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AdminColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetCtx) {
        return BlocProvider.value(
          value: bloc,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
            ),
            child: BlocBuilder<OffersManagementBloc, OffersManagementState>(
              builder: (ctx, s) => CreateOfferSheet(
                form: s.form,
                dispatch: (ev) => ctx.read<OffersManagementBloc>().add(ev),
              ),
            ),
          ),
        );
      },
    );

    _sheetOpen = false;

    // إذا انسكر بالسحب، خلّي البلوك يعرف
    if (mounted) {
      final st = context.read<OffersManagementBloc>().state;
      if (st.createOpen) {
        context.read<OffersManagementBloc>().add(const OffersManagementCreateClosed());
      }
    }
  }

  void _closeSheetIfOpen() {
    if (!_sheetOpen) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    _sheetOpen = false;
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offer created successfully'),
        backgroundColor: AdminColors.success,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AdminColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: MultiBlocListener(
          listeners: [
            // فتح الشيت مرة واحدة فقط
            BlocListener<OffersManagementBloc, OffersManagementState>(
              listenWhen: (p, n) => p.createOpen != n.createOpen && n.createOpen == true,
              listener: (context, state) async {
                await _openCreateSheet(context);
              },
            ),

            // نجاح الإنشاء => اغلاق + نجاح
            BlocListener<OffersManagementBloc, OffersManagementState>(
              listenWhen: (p, n) =>
                  p.status == OffersManagementStatus.creating &&
                  n.status == OffersManagementStatus.ready,
              listener: (context, state) {
                _closeSheetIfOpen();
                _showSuccess();
              },
            ),

            // فشل الإنشاء
            BlocListener<OffersManagementBloc, OffersManagementState>(
              listenWhen: (p, n) =>
                  p.status != n.status &&
                  n.status == OffersManagementStatus.failure &&
                  n.error != null,
              listener: (context, state) {
                _showError(state.error!);
              },
            ),
          ],
          child: BlocBuilder<OffersManagementBloc, OffersManagementState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 390),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdminAppBar(
                            title: 'Offers',
                            subtitle: 'Discounts & packages',
                            onBack: widget.fromHome ? () => Navigator.of(context).maybePop() : null,
                          ),

                          InkWell(
                            onTap: () => context.read<OffersManagementBloc>().add(const OffersManagementCreateOpened()),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: AdminColors.primaryBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Create Offer',
                                style: AdminText.body16(color: Colors.white, w: FontWeight.w700),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          if (state.status == OffersManagementStatus.loading)
                            const SizedBox(height: 520, child: AdminListSkeleton(count: 6, height: 120))
                          else if (state.offers.isEmpty)
                            AdminEmptyState(
                              title: 'No offers',
                              subtitle: 'Create your first discount or package offer.',
                              icon: AdminIconMapper.analytics(),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.offers.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (_, i) {
                                final o = state.offers[i];
                                return OfferCard(
                                  offer: o,
                                  onToggle: (v) => context.read<OffersManagementBloc>().add(
                                        OffersManagementTogglePressed(o.id, v),
                                      ),
                                );
                              },
                            ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
