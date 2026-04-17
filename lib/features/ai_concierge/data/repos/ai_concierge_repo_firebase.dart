import '../../domain/entities/concierge_message.dart';
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
  Future<ConciergeMessage> sendMessage({
    required String message,
    required String lang,
  }) async {
    final rawText = await _source.sendMessage(message: message, lang: lang);
    final parsed = _parseReply(rawText);

    return ConciergeMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      sender: ConciergeSender.bot,
      text: parsed.cleanedText,
      actionSpaceId: parsed.spaceId,
    );
  }

  _ParsedReply _parseReply(String text) {
    final match = _actionRegex.firstMatch(text);

    String cleanedText = text;

    // إزالة ACTION
    if (match != null) {
      cleanedText = cleanedText.replaceAll(match.group(0)!, '');
    }

    // 🔥 تنظيف النص
    cleanedText = cleanedText
        .replaceAll('**', '')
        .replaceAll('-', '')
        .replaceAll(RegExp(r'\n{2,}'), '\n')
        .trim();

    // 🔥 ترتيب الأسطر
    final lines = cleanedText.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    cleanedText = lines.join('\n');

    final spaceId = match != null ? (match.group(1) ?? '').trim() : null;

    return _ParsedReply(
      cleanedText: cleanedText,
      spaceId: spaceId == null || spaceId.isEmpty ? null : spaceId,
    );
  }
}

class _ParsedReply {
  const _ParsedReply({required this.cleanedText, required this.spaceId});

  final String cleanedText;
  final String? spaceId;
}