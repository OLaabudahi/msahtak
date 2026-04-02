import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_edit_space_source.dart';
import '../models/amenity_model.dart';
import '../models/space_form_model.dart';


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
        paymentMethods: const [],
      );
    }

    final doc = await _db.collection('spaces').doc(spaceId).get();
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
      data['availableSeats'] = form.totalSeats;
      final docRef = await _db.collection('spaces').add(data);

      
      if (form.adminId != null && form.adminId!.isNotEmpty) {
        await _assignSpaceToAdmin(spaceId: docRef.id, newAdminId: form.adminId!, oldAdminId: null);
      }
    } else {
      
      data.remove('availableSeats');
      String? oldAdminId;
      try {
        final old = await _db.collection('spaces').doc(form.id).get();
        oldAdminId = old.data()?['adminId'] as String?;
      } catch (_) {}

      await _db.collection('spaces').doc(form.id).set(data, SetOptions(merge: true));

      
      final newAdminId = form.adminId;
      if (oldAdminId != newAdminId) {
        await _assignSpaceToAdmin(spaceId: form.id!, newAdminId: newAdminId, oldAdminId: oldAdminId);
      }
    }
  }

  
  Future<void> _assignSpaceToAdmin({
    required String spaceId,
    required String? newAdminId,
    required String? oldAdminId,
  }) async {
    
    if (oldAdminId != null && oldAdminId.isNotEmpty) {
      try {
        final oldDoc = await _db.collection('users').doc(oldAdminId).get();
        if (oldDoc.exists) {
          final ids = List<String>.from(oldDoc.data()?['assignedSpaceIds'] ?? []);
          ids.remove(spaceId);
          await _db.collection('users').doc(oldAdminId).update({'assignedSpaceIds': ids});
        }
      } catch (_) {}
    }

    
    if (newAdminId != null && newAdminId.isNotEmpty) {
      try {
        final newDoc = await _db.collection('users').doc(newAdminId).get();
        if (newDoc.exists) {
          final ids = List<String>.from(newDoc.data()?['assignedSpaceIds'] ?? []);
          if (!ids.contains(spaceId)) ids.add(spaceId);
          await _db.collection('users').doc(newAdminId).update({'assignedSpaceIds': ids});
        }
      } catch (_) {}
    }
  }
}
