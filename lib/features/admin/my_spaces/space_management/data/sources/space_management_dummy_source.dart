import 'space_management_source.dart';
import '../models/space_management_model.dart';

class SpaceManagementDummySource implements SpaceManagementSource {
  final List<SpaceManagementModel> _list = [
    const SpaceManagementModel(id: 's1', name: 'Downtown Hub', hidden: false),
    const SpaceManagementModel(id: 's2', name: 'Creative Studio', hidden: false),
    const SpaceManagementModel(id: 's3', name: 'Tech Center', hidden: true),
  ];

  @override
  Future<SpaceManagementModel> fetchSpace({required String spaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    return _list.firstWhere((e) => e.id == spaceId, orElse: () => const SpaceManagementModel(id: 's1', name: 'Downtown Hub', hidden: false));
  }

  @override
  Future<void> setHidden({required String spaceId, required bool hidden}) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].id == spaceId) {
        _list[i] = SpaceManagementModel(id: _list[i].id, name: _list[i].name, hidden: hidden);
      }
    }
  }
}


