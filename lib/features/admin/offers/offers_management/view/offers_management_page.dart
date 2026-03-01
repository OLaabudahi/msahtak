import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared/admin_ui.dart';

import '../bloc/offers_bloc.dart';
import '../bloc/offers_event.dart';
import '../bloc/offers_state.dart';
import '../data/repos/offers_repo_impl.dart';
import '../data/sources/offers_dummy_source.dart';
import '../domain/usecases/create_offer_usecase.dart';
import '../domain/usecases/get_offers_usecase.dart';
import '../domain/usecases/toggle_offer_usecase.dart';

class OffersManagementPage extends StatefulWidget {
  final bool fromHome;
  const OffersManagementPage({super.key, required this.fromHome});

  static Widget withBloc({bool fromHome = false}) {
    final source = OffersDummySource();
    final repo = OffersRepoImpl(source);
    return BlocProvider(
      create: (_) => OffersBloc(
        getOffers: GetOffersUseCase(repo),
        toggleOffer: ToggleOfferUseCase(repo),
        createOffer: CreateOfferUseCase(repo),
      )..add(const OffersStarted()),
      child: OffersManagementPage(fromHome: fromHome),
    );
  }

  @override
  State<OffersManagementPage> createState() => _OffersManagementPageState();
}

class _OffersManagementPageState extends State<OffersManagementPage> {
  Future<void> _openCreate(BuildContext context) async {
    final title = TextEditingController();
    final percent = TextEditingController();
    final duration = TextEditingController();
    final terms = TextEditingController();
    bool enabled = true;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AdminColors.bg,
      barrierColor: const Color(0x66000000),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: AdminRadii.r24)),
      builder: (ctx) {
        final inset = MediaQuery.of(ctx).viewInsets.bottom;
        return StatefulBuilder(
          builder: (ctx2, setLocal) {
            return Padding(
              padding: EdgeInsets.only(bottom: inset),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create Offer', style: AdminText.h2()),
                        const SizedBox(height: 16),
                        _F(label: 'Title', c: title),
                        const SizedBox(height: 12),
                        _F(label: 'Percent', c: percent, hint: 'e.g. 10%'),
                        const SizedBox(height: 12),
                        _F(label: 'Duration', c: duration, hint: 'e.g. 7 days'),
                        const SizedBox(height: 12),
                        _F(label: 'Terms', c: terms, maxLines: 3),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: Text('Enabled', style: AdminText.body16(w: FontWeight.w600))),
                            Switch(value: enabled, onChanged: (v) => setLocal(() => enabled = v), activeColor: AdminColors.primaryBlue),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: AdminButton.outline(label: 'Back', onTap: () => Navigator.of(ctx).pop(), bg: AdminColors.black15, fg: AdminColors.text)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AdminButton.filled(
                                label: 'Create',
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  context.read<OffersBloc>().add(OffersCreatePressed(title.text.trim(), percent.text.trim(), duration.text.trim(), terms.text.trim(), enabled));
                                },
                                bg: AdminColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    title.dispose();
    percent.dispose();
    duration.dispose();
    terms.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminAppBar(
                    title: 'Offers Management',
                    subtitle: 'Create and manage offers',
                    onBack: widget.fromHome ? () => Navigator.of(context).maybePop() : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AdminButton.filled(label: 'Create Offer', onTap: () => _openCreate(context), bg: AdminColors.primaryBlue),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BlocBuilder<OffersBloc, OffersState>(
                      builder: (context, state) {
                        return Column(
                          children: state.offers.map((o) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AdminCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(o.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body16(w: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    Text('${o.percent} • ${o.duration}', maxLines: 1, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black75)),
                                    const SizedBox(height: 8),
                                    Text(o.terms, maxLines: 2, overflow: TextOverflow.ellipsis, style: AdminText.body14(color: AdminColors.black40)),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(child: Text('Enabled', style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w600))),
                                        Switch(
                                          value: o.enabled,
                                          onChanged: (v) => context.read<OffersBloc>().add(OffersTogglePressed(o.id, v)),
                                          activeColor: AdminColors.primaryBlue,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(growable: false),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _F extends StatelessWidget {
  final String label;
  final TextEditingController c;
  final String? hint;
  final int maxLines;
  const _F({required this.label, required this.c, this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AdminText.body14(color: AdminColors.black75, w: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: c,
          maxLines: maxLines,
          style: AdminText.body16(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AdminText.body16(color: AdminColors.black40),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AdminColors.black15, width: 1)),
          ),
        ),
      ],
    );
  }
}
