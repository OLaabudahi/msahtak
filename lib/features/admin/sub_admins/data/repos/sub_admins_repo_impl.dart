import '../../domain/repos/sub_admins_repo.dart';
import '../sources/sub_admins_firebase_source.dart';

class SubAdminsRepoImpl implements SubAdminsRepo {
  final SubAdminsFirebaseSource source;

  SubAdminsRepoImpl(this.source);

  @override
  Future<List<Map<String, dynamic>>> getSpaces() {
    return source.fetchSpaces();
  }
}