import 'add_edit_space_source.dart';
import '../models/space_form_model.dart';

class AddEditSpaceDummySource implements AddEditSpaceSource {
  @override
  Future<SpaceFormModel> fetchSpaceForm({required String? spaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (spaceId == null) {
      return const SpaceFormModel(
        id: null,
        name: '',
        address: '',
        price: '',
        description: '',
        amenities: [
          {'id': 'a1', 'name': 'WiFi', 'selected': true},
          {'id': 'a2', 'name': 'Electricity', 'selected': true},
          {'id': 'a3', 'name': 'Meeting Room', 'selected': false},
          {'id': 'a4', 'name': 'Coffee', 'selected': false},
        ],
        hours: '',
        policies: '',
        hidden: false,
      );
    }

    return const SpaceFormModel(
      id: 's1',
      name: 'Downtown Hub',
      address: '123 Main St, City Center',
      price: '\$50/hour',
      description: 'Modern co-working space with fast WiFi.',
      amenities: [
        {'id': 'a1', 'name': 'WiFi', 'selected': true},
        {'id': 'a2', 'name': 'Electricity', 'selected': true},
        {'id': 'a3', 'name': 'Meeting Room', 'selected': true},
        {'id': 'a4', 'name': 'Coffee', 'selected': false},
      ],
      hours: 'Sun-Thu 9:00 AM - 7:00 PM',
      policies: 'No smoking. Keep the area clean.',
      hidden: false,
    );
  }

  @override
  Future<void> saveSpace({required SpaceFormModel form}) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
  }
}
