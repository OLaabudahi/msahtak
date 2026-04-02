import 'dart:async';
import '../../../../core/services/firestore_api.dart';

import '../../domain/entities/concierge_message.dart';
import '../../domain/entities/concierge_step_payload.dart';
import '../../domain/entities/concierge_top_match.dart';
import '../../domain/repos/ai_concierge_repo.dart';

class AiConciergeRepoDummy implements AiConciergeRepo {
  int _step = 1;

  String? _purpose;
  String? _duration;

  final FirestoreApi firestoreApi = FirestoreApi();

  @override
  Future<ConciergeStepPayload> start() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    _step = 1;
    _purpose = null;
    _duration = null;

    return const ConciergeStepPayload(
      stepIndex: 1,
      totalSteps: 4,
      stepMeta: 'Step 1 of 4 â€¢ 30 sec',
      newMessages: [
        ConciergeMessage(
          id: 'm1',
          sender: ConciergeSender.bot,
          text: 'Hi! What is your purpose?',
        ),
      ],
      quickReplies: ['Study', 'Work', 'Meeting'],
      topMatch: null,
      showContinueButton: false,
    );
  }

  @override
  Future<ConciergeStepPayload> selectQuickReply({required String reply}) async {
    return submitUserAnswer(answer: reply);
  }

  @override
  Future<ConciergeStepPayload> submitUserAnswer({required String answer}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (_step == 1) {
      _purpose = answer.toLowerCase();
      _step = 2;

      return ConciergeStepPayload(
        stepIndex: 2,
        totalSteps: 4,
        stepMeta: 'Step 2 of 4 â€¢ 30 sec',
        newMessages: [
          ConciergeMessage(id: 'u1', sender: ConciergeSender.user, text: answer),
          const ConciergeMessage(
            id: 'b2',
            sender: ConciergeSender.bot,
            text: 'Great. How long do you need the space?',
          ),
        ],
        quickReplies: const ['Today', 'Weekly', 'Monthly'],
        topMatch: null,
        showContinueButton: false,
      );
    }

    if (_step == 2) {
      _duration = answer.toLowerCase();
      _step = 3;

      final topMatch = await _getBestMatchFromFirebase();

      return ConciergeStepPayload(
        stepIndex: 3,
        totalSteps: 4,
        stepMeta: 'Step 3 of 4 â€¢ 30 sec',
        newMessages: [
          ConciergeMessage(id: 'u2', sender: ConciergeSender.user, text: answer),
        ],
        quickReplies: [],
        topMatch: topMatch,
        showContinueButton: true,
      );
    }

    _step = 4;

    final topMatch = await _getBestMatchFromFirebase();

    return ConciergeStepPayload(
      stepIndex: 4,
      totalSteps: 4,
      stepMeta: 'Step 4 of 4 â€¢ 30 sec',
      newMessages: const [
        ConciergeMessage(
          id: 'b4',
          sender: ConciergeSender.bot,
          text: 'All set. You can continue to booking.',
        ),
      ],
      quickReplies: const [],
      topMatch: topMatch,
      showContinueButton: true,
    );
  }

  /// ًں”¥ ظ‡ظ†ط§ ط§ظ„ط°ظƒط§ط، ط§ظ„ط­ظ‚ظٹظ‚ظٹ
  Future<ConciergeTopMatch> _getBestMatchFromFirebase() async {
    final spaces = await firestoreApi.getCollection(collection: 'spaces');

    final filtered = spaces.where((space) {
      final isQuiet = space['quiet'] == true;

      final matchPurpose = _purpose == null ||
          space['type']?.toString().toLowerCase() == _purpose;

      final matchDuration = _duration == null ||
          (space['plans'] as List).contains(_duration);

      return isQuiet && matchPurpose && matchDuration;
    }).toList();

    if (filtered.isEmpty) {
      throw Exception('No matching spaces found');
    }

    /// طھط±طھظٹط¨ ط­ط³ط¨ ط§ظ„ط£ظپط¶ظ„
    filtered.sort((a, b) => _score(b).compareTo(_score(a)));

    final best = filtered.first;

    String why = "";

    if (best['quiet'] == true) why += "ظ‡ط§ط¯ط¦ â€¢ ";
    if (best['wifi'] == 'strong') why += "WiFi ظ‚ظˆظٹ â€¢ ";
    if ((best['distance'] ?? 100) < 15) why += "ظ‚ط±ظٹط¨ â€¢ ";

    return ConciergeTopMatch(
      spaceId: best['id'],
      title: "Top Match: ${best['name']}",
      whyLine: "Why: $why",
      planLine: "Plan suggestion: ${_duration?.toUpperCase()} ظٹظˆظپط± ط£ظƒط«ط± ًں’°",
      priceLine:
      "Daily â‚ھ${best['priceDaily']} â€¢ Weekly â‚ھ${best['priceWeekly']}",
      imageAsset: 'assets/images/home.png',
    );
  }

  /// ًں”¥ ظ†ط¸ط§ظ… طھظ‚ظٹظٹظ… (ط°ظƒط§ط، ط¨ط³ظٹط·)
  int _score(Map space) {
    int s = 0;

    if (space['quiet'] == true) s += 3;
    if (space['wifi'] == 'strong') s += 2;
    if ((space['distance'] ?? 100) < 10) s += 2;

    return s;
  }
}

