import 'add_edit_space_source.dart';
import '../models/amenity_model.dart';
import '../models/space_form_model.dart';

class AddEditSpaceDummySource implements AddEditSpaceSource {
  final List<AmenityModel> _catalog = [
    const AmenityModel(id: 'a1', name: 'WiFi', selected: false, isCustom: false),
    const AmenityModel(id: 'a2', name: 'Electricity', selected: false, isCustom: false),
    const AmenityModel(id: 'a3', name: 'Meeting Room', selected: false, isCustom: false),
    const AmenityModel(id: 'a4', name: 'Coffee', selected: false, isCustom: false),
  ];

  @override
  Future<List<AmenityModel>> fetchAmenityCatalog() async {
    await Future<void>.delayed(const Duration(milliseconds: 140));
    return List<AmenityModel>.from(_catalog);
  }

  @override
  Future<AmenityModel> createAmenity({required String name}) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final m = AmenityModel(id: id, name: name, selected: false, isCustom: true);
    _catalog.insert(0, m);
    return m;
  }

  @override
  Future<SpaceFormModel> fetchSpaceForm({required String? spaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 140));

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
        amenities: _catalog.map((a) => a.toJson()).toList(growable: false),
        hidden: false,
      );
    }

    return SpaceFormModel(
      id: spaceId,
      name: 'Downtown Hub',
      address: '12 King St, Downtown',
      description: '',
      price: '₪35/day',
      hours: 'Sun - Thu, 8:00 AM - 10:00 PM',
      policies: 'Please read before booking.',
      basePriceValue: 35,
      basePriceUnit: 'day',
      location: const {'lat': 31.9539, 'lng': 35.9106},
      workingHours: const [
        {'day': 'sun', 'open': '08:00', 'close': '22:00', 'closed': false},
        {'day': 'mon', 'open': '08:00', 'close': '22:00', 'closed': false},
        {'day': 'tue', 'open': '08:00', 'close': '22:00', 'closed': false},
        {'day': 'wed', 'open': '08:00', 'close': '22:00', 'closed': false},
        {'day': 'thu', 'open': '08:00', 'close': '22:00', 'closed': false},
        {'day': 'fri', 'open': '08:00', 'close': '22:00', 'closed': true},
        {'day': 'sat', 'open': '08:00', 'close': '22:00', 'closed': true},
      ],
      policySections: const [
        {'id': 'p1', 'title': 'Noise & Calls', 'bullets': ['Quiet zones are available.', 'Calls allowed in designated areas.']},
        {'id': 'p2', 'title': 'Food & Drinks', 'bullets': ['Drinks allowed at desks.', 'Please clean your table.']},
      ],
      amenities: _catalog.map((a) {
        
        final selected = (a.id == 'a1' || a.id == 'a2');
        return AmenityModel(id: a.id, name: a.name, selected: selected, isCustom: a.isCustom).toJson();
      }).toList(growable: false),
      hidden: false,
    );
  }

  @override
  Future<void> saveSpace({required SpaceFormModel form}) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
  }
}
