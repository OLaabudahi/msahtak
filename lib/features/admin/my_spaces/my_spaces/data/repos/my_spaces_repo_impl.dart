import '../../domain/entities/space_entity.dart';
import '../../domain/repos/my_spaces_repo.dart';
import '../sources/my_spaces_source.dart';

class MySpacesRepoImpl implements MySpacesRepo {
  final MySpacesSource source;
  const MySpacesRepoImpl(this.source);

  @override
  Future<List<SpaceEntity>> getSpaces() async {
    final models = await source.fetchSpaces();
    return models.map((m) => m.toEntity()).toList(growable: false);
  }

  @override
  Future<void> hideSpace({required String spaceId}) => source.hideSpace(spaceId: spaceId);

  @override
  Future<void> deleteSpace({required String spaceId}) => source.deleteSpace(spaceId: spaceId);
}


