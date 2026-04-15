import '../sources/ai_concierge_remote_source.dart';
import 'ai_concierge_repo_firebase.dart';

class AiConciergeRepoDummy extends AiConciergeRepoFirebase {
  AiConciergeRepoDummy() : super(source: AiConciergeRemoteSource());
}
