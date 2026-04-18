import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/i18n/app_i18n.dart';
import '../../../services/language_service.dart';
import '../../../theme/app_colors.dart';
import '../../space_details/view/space_details_page.dart';
import '../bloc/ai_concierge_bloc.dart';
import '../bloc/ai_concierge_event.dart';
import '../bloc/ai_concierge_state.dart';
import '../data/repos/ai_concierge_repo_dummy.dart';
import '../domain/usecases/start_concierge_usecase.dart';
import '../domain/usecases/submit_answer_usecase.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class AiConciergePage extends StatefulWidget {
  const AiConciergePage({super.key});

  static Widget withBloc() {
    final repo = AiConciergeRepoDummy();

    return BlocProvider(
      create: (_) => AiConciergeBloc(
        startUseCase: StartConciergeUseCase(repo),
        submitAnswerUseCase: SubmitAnswerUseCase(repo),
      ),
      child: const AiConciergePage(),
    );
  }

  @override
  State<AiConciergePage> createState() => _AiConciergePageState();
}

class _AiConciergePageState extends State<AiConciergePage> {
  final ScrollController _scrollController = ScrollController();
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final code = context.isArabic ? 'ar' : LanguageService.supported.first.code;
    context.read<AiConciergeBloc>().add(AiConciergeStarted(lang: code));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.switchThumb,
        title:  Text(context.t('aiAssistantName')),
      ),
      body: BlocConsumer<AiConciergeBloc, AiConciergeState>(
        listenWhen: (prev, next) =>
            prev.messages.length != next.messages.length || prev.error != next.error,
        listener: (context, state) {
          _scrollToLatest();
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  children: [
                    if (state.messages.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 36),
                        child: Center(
                          child: Text(
                            context.t('emptyChat'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ...state.messages.map(
                      (message) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child:ChatBubble(
                          message: message,
                          onActionTap: (spaceId) {
                            _openSpaceDetails(context, spaceId);
                          },
                        ),
                        /* ChatBubble(
                          message: message,
                          onActionTap: (spaceId) => _openSpaceDetails(context, spaceId),
                        ),*/
                      ),
                    ),
                    if (state.loading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            context.t('typing'),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            context.t('errorMessage'),
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              ChatInputBar(
                onSend: (text) {
                  final code = context.isArabic ? 'ar' : LanguageService.supported.first.code;
                  context.read<AiConciergeBloc>().add(SendMessage(message: text, lang: code));
                },
              ),
            ],
          );
        },
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
