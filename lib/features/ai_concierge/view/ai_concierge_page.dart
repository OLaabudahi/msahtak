import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../space_details/view/space_details_page.dart';
import '../bloc/ai_concierge_bloc.dart';
import '../bloc/ai_concierge_event.dart';
import '../bloc/ai_concierge_state.dart';
import '../data/repos/ai_concierge_repo_dummy.dart';
import '../domain/usecases/select_quick_reply_usecase.dart';
import '../domain/usecases/start_concierge_usecase.dart';
import '../domain/usecases/submit_answer_usecase.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/quick_reply_chips.dart' ;
import '../widgets/top_match_card.dart';

class AiConciergePage extends StatelessWidget {
  const AiConciergePage({super.key});

  static Widget withBloc() {
    final repo = AiConciergeRepoDummy();

    return BlocProvider(
      create: (_) => AiConciergeBloc(
        startUseCase: StartConciergeUseCase(repo),
        submitAnswerUseCase: SubmitAnswerUseCase(repo),
        selectQuickReplyUseCase: SelectQuickReplyUseCase(repo),
      )..add(const AiConciergeStarted()),
      child: const AiConciergePage(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Concierge'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AiConciergeBloc, AiConciergeState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == AiConciergeStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            final isLoading = state.status == AiConciergeStatus.loading;

            return Column(
              children: [
                // Step meta
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      state.stepMeta,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    itemCount: state.messages.length + (state.topMatch != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Top match card يظهر بعد الرسائل (قريب من الصورة)
                      if (state.topMatch != null && index == state.messages.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: TopMatchCard(
                            data: state.topMatch!,
                            onOpenSpace: () => _openSpaceDetails(context, state.topMatch!.spaceId),
                            onContinue: state.showContinueButton
                                ? () => _openSpaceDetails(context, state.topMatch!.spaceId)
                                : null,
                          ),
                        );
                      }

                      final msg = state.messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ChatBubble(message: msg),
                      );
                    },
                  ),
                ),

                if (state.quickReplies.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: QuickReplyChips(
                      options: state.quickReplies,
                      onSelected: (v) => context.read<AiConciergeBloc>().add(AiConciergeQuickReplySelected(v)),
                    ),
                  ),

                if (isLoading) const LinearProgressIndicator(minHeight: 2),

                ChatInputBar(
                  onSend: (text) => context.read<AiConciergeBloc>().add(AiConciergeUserTextSent(text)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openSpaceDetails(BuildContext context, String spaceId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SpaceDetailsPage.withBloc(spaceId: spaceId),
      ),
    );
  }
}