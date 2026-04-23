import '../../domain/entities/concierge_message.dart';
import '../../domain/entities/concierge_reply.dart';
import '../../domain/repos/ai_concierge_repo.dart';
import '../sources/ai_concierge_remote_source.dart';

class AiConciergeRepoFirebase implements AiConciergeRepo {
  AiConciergeRepoFirebase({required AiConciergeRemoteSource source}) : _source = source;

  final AiConciergeRemoteSource _source;
  final RegExp _actionRegex = RegExp(r'\[ACTION:([^\]]+)\]');

  @override
  Future<ConciergeMessage> createGreeting({required String lang}) async {
    return ConciergeMessage(
      id: 'initial_ai_message',
      sender: ConciergeSender.bot,
      text: lang == 'ar' ? 'كيف أقدر أساعدك؟' : 'How can I help you?',
    );
  }

  @override
  Future<ConciergeReply> sendMessage({
    required String message,
    required String userId,
    required List<Map<String, dynamic>> history,
    required List<String> lastSpaces,
  }) async {
    final raw = await _source.sendMessage(
      message: message,
      userId: userId,
      history: history,
      lastSpaces: lastSpaces,
    );

    final rawText = (raw['text'] ?? '').toString();
    final parsed = _parseReply(rawText);
    final spaces = (raw['currentSpaces'] is List)
        ? (raw['currentSpaces'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];

    final actions = parsed.spaceIds
        .map((spaceId) {
          final actionSpaceName = spaces
              .where((s) =>
                  (s['id'] ?? s['spaceId'] ?? s['_id'] ?? '').toString() == spaceId)
              .map((s) => (s['name'] ?? s['title'] ?? s['spaceName'] ?? '').toString())
              .firstWhere((name) => name.isNotEmpty, orElse: () => '');

          return ConciergeAction(
            spaceId: spaceId,
            spaceName: actionSpaceName.toString().isEmpty ? null : actionSpaceName,
          );
        })
        .where((action) => action.spaceId.isNotEmpty)
        .toList();

    final firstAction = actions.isNotEmpty ? actions.first : null;

    return ConciergeReply(
      message: ConciergeMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        sender: ConciergeSender.bot,
        text: parsed.cleanedText,
        actionSpaceId: firstAction?.spaceId,
        actionSpaceName:
            firstAction?.spaceName.toString().isEmpty == true ? null : firstAction?.spaceName,
        actions: actions,
      ),
      currentSpaces: spaces,
    );
  }

  @override
  Future<void> finalizeSession({
    required String userId,
    required List<Map<String, dynamic>> history,
  }) {
    return _source.finalizeSession(userId: userId, history: history);
  }

  _ParsedReply _parseReply(String text) {
    final matches = _actionRegex
        .allMatches(text)
        .map((m) => (m.group(1) ?? '').trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    String cleanedText = text;

    cleanedText = cleanedText.replaceAll(_actionRegex, '');

    cleanedText = cleanedText
        .replaceAll('**', '')
        .replaceAll('-', '')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();

    final lines =
        cleanedText.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    cleanedText = lines.join('\n');

    return _ParsedReply(
      cleanedText: cleanedText,
      spaceIds: matches,
    );
  }
}

class _ParsedReply {
  const _ParsedReply({required this.cleanedText, required this.spaceIds});

  final String cleanedText;
  final List<String> spaceIds;
}
