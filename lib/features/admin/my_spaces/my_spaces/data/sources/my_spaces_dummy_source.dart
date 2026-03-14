import 'my_spaces_source.dart';
import '../models/space_model.dart';

class MySpacesDummySource implements MySpacesSource {
  final List<SpaceModel> _list = [
    const SpaceModel(id: 's1', name: 'Downtown Hub', rating: '4.8', availability: 'available', cover: ''),
    const SpaceModel(id: 's2', name: 'Creative Studio', rating: '4.6', availability: 'available', cover: ''),
    const SpaceModel(id: 's3', name: 'Tech Center', rating: '4.7', availability: 'hidden', cover: ''),
  ];

  @override
  Future<List<SpaceModel>> fetchSpaces() async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    return List<SpaceModel>.from(_list);
  }

  @override
  Future<void> hideSpace({required String spaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].id == spaceId) {
        _list[i] = SpaceModel(id: _list[i].id, name: _list[i].name, rating: _list[i].rating, availability: 'hidden', cover: _list[i].cover);
      }
    }
  }

  @override
  Future<void> deleteSpace({required String spaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _list.removeWhere((s) => s.id == spaceId);
  }
}
