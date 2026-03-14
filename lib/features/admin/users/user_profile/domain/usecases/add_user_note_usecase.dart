import '../repos/user_profile_repo.dart';

class AddUserNoteUseCase {
  final UserProfileRepo repo;
  const AddUserNoteUseCase(this.repo);

  Future<void> call({required String userId, required String note}) => repo.addNote(userId: userId, note: note);
}
