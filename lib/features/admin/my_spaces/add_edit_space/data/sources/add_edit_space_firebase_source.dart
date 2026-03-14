import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_edit_space_source.dart';
import '../models/amenity_model.dart';
import '../models/space_form_model.dart';

/// مصدر Firebase لإضافة/تعديل المساحات — يقرأ/يكتب من spaces collection
class AddEditSpaceFirebaseSource implements AddEditSpaceSource {
  final _db = FirebaseFirestore.instance;

  static const List<Map<String, dynamic>> _defaultAmenities = [
    {'id': 'a1', 'name': 'WiFi', 'selected': false, 'isCustom': false},
    {'id': 'a2', 'name': 'Electricity', 'selected': false, 'isCustom': false},
    {'id': 'a3', 'name': 'Meeting Room', 'selected': false, 'isCustom': false},
    {'id': 'a4', 'name': 'Coffee', 'selected': false, 'isCustom': false},
    {'id': 'a5', 'name': 'Parking', 'selected': false, 'isCustom': false},
    {'id': 'a6', 'name': 'Printer', 'selected': false, 'isCustom': false},
  ];

  @override
  Future<List<AmenityModel>> fetchAmenityCatalog() async {
    return _defaultAmenities.map(AmenityModel.fromJson).toList();
  }

  @override
  Future<AmenityModel> createAmenity({required String name}) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    return AmenityModel(id: id, name: name, selected: false, isCustom: true);
  }

  @override
  Future<SpaceFormModel> fetchSpaceForm({required String? spaceId}) async {
    if (spaceId == null) {
      return SpaceFormModel(
        id: null,
        name: '',
        address: '',
        description: '',
        price: '',
        hours: '',
        policies: '',
        basePriceValue: 0,
        basePriceUnit: 'day',
        location: null,
        workingHours: const [],
        policySections: const [],
        amenities: _defaultAmenities,
        hidden: false,
      );
    }

    final doc = await _db.collection('workspaces').doc(spaceId).get();
    if (!doc.exists) {
      return SpaceFormModel(
        id: spaceId,
        name: '',
        address: '',
        description: '',
        price: '',
        hours: '',
        policies: '',
        basePriceValue: 0,
        basePriceUnit: 'day',
        location: null,
        workingHours: const [],
        policySections: const [],
        amenities: _defaultAmenities,
        hidden: false,
      );
    }

    final d = doc.data()!;
    d['id'] = doc.id;
    return SpaceFormModel.fromJson(d);
  }

  @override
  Future<void> saveSpace({required SpaceFormModel form}) async {
    final data = form.toJson();
    data.remove('id');
    data['updatedAt'] = FieldValue.serverTimestamp();

    if (form.id == null) {
      data['createdAt'] = FieldValue.serverTimestamp();
      data['availableSeats'] = form.totalSeats; // initialize on creation
      await _db.collection('workspaces').add(data);
    } else {
      // Don't overwrite availableSeats on edit — it tracks real-time availability
      data.remove('availableSeats');
      await _db.collection('workspaces').doc(form.id).set(data, SetOptions(merge: true));
    }
  }
}
