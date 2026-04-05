import 'package:Msahtak/features/admin/my_spaces/add_edit_space/domain/entities/price_entity.dart';

import '../../domain/entities/space_form_entity.dart';
import '../../domain/entities/price_unit.dart';
import '../models/amenity_model.dart';
import '../models/policy_section_model.dart';
import '../models/price_unit_model.dart';
import '../models/space_location_model.dart';
import '../models/working_hours_model.dart';

class SpaceFormModel {
  final String? id;

  final String name;
  final String address;
  final String description;

  final String price;
  final String hours;
  final String policies;

  final double basePriceValue;
  final String basePriceUnit;

  final Map<String, dynamic>? location;
  final List<Map<String, dynamic>> workingHours;
  final List<Map<String, dynamic>> policySections;
  final List<Map<String, dynamic>> amenities;
  final List<String> images;

  final bool hidden;
  final int totalSeats;
  final String? adminId;
  final String? adminName;
  final List<Map<String, String>> paymentMethods;

  /// ✅ CLEAN MODEL
  final List<PriceEntity> extraPrices;

  const SpaceFormModel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.price,
    required this.hours,
    required this.policies,
    required this.basePriceValue,
    required this.basePriceUnit,
    required this.location,
    required this.workingHours,
    required this.policySections,
    required this.amenities,
    this.images = const [],
    required this.hidden,
    this.totalSeats = 0,
    this.adminId,
    this.adminName,
    this.paymentMethods = const [],
    this.extraPrices = const [],
  });



  factory SpaceFormModel.fromJson(Map<String, dynamic> json) {
    final prices = (json['prices'] as List?) ?? [];

    return SpaceFormModel(
      id: json['id']?.toString(),
      name: (json['name'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      hours: (json['hours'] ?? '').toString(),
      policies: (json['policies'] ?? '').toString(),

      /// ✅ base
      basePriceValue: prices.isNotEmpty
          ? (prices.first['value'] as num?)?.toDouble() ?? 0
          : 0,

      basePriceUnit: prices.isNotEmpty
          ? (prices.first['unit'] ?? 'day').toString()
          : 'day',

      /// ✅ extraPrices FIXED
      extraPrices: prices.length > 1
          ? prices.sublist(1).map((e) {
        return PriceEntity(
          value: (e['value'] as num).toDouble(),
          unit: _unitFromString(e['unit'] as String),
        );
      }).toList()
          : [],

      location: (json['location'] as Map?)?.cast<String, dynamic>(),
      workingHours: (json['workingHours'] as List?)
          ?.map((e) => (e as Map).cast<String, dynamic>())
          .toList(growable: false) ??
          const [],
      policySections: (json['policySections'] as List?)
          ?.map((e) => (e as Map).cast<String, dynamic>())
          .toList(growable: false) ??
          const [],
      amenities: (json['amenities'] as List?)
          ?.map((e) => (e as Map).cast<String, dynamic>())
          .toList(growable: false) ??
          const [],
      images: (json['images'] as List?)?.cast<String>() ?? const [],
      hidden: (json['hidden'] ?? false) == true,
      totalSeats: (json['totalSeats'] as num?)?.toInt() ?? 0,
      adminId: json['adminId'] as String?,
      adminName: json['adminName'] as String?,
      paymentMethods: (json['paymentMethods'] as List?)
          ?.map((e) => (e as Map).map((k, v) => MapEntry(k.toString(), v.toString())))
          .toList(growable: false) ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    final prices = [
      {
        'value': basePriceValue,
        'unit': basePriceUnit,
      },

      /// 🔥 FIX هنا
      ...extraPrices.map((e) => {
        'value': e.value,
        'unit': e.unit.name,
      }),
    ];

    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'price': price,
      'hours': hours,
      'policies': policies,
      'basePriceValue': basePriceValue,
      'basePriceUnit': basePriceUnit,
      'location': location,
      'workingHours': workingHours,
      'policySections': policySections,
      'amenities': amenities,
      'prices': prices,
      'images': images,
      'hidden': hidden,
      'totalSeats': totalSeats,
      'adminId': adminId,
      'adminName': adminName,
      'paymentMethods': paymentMethods,
    };
  }

  SpaceFormEntity toEntity() {
    final unit = PriceUnitModel.fromJson(basePriceUnit);

    final loc = (location == null)
        ? null
        : SpaceLocationModel.fromJson(location!).toEntity();

    final wh = workingHours
        .map((m) => WorkingHoursModel.fromJson(m).toEntity())
        .toList(growable: false);

    final ps = policySections
        .map((m) => PolicySectionModel.fromJson(m).toEntity())
        .toList(growable: false);

    final am = amenities
        .map((m) => AmenityModel.fromJson(m).toEntity())
        .toList(growable: false);

    return SpaceFormEntity(
      id: id,
      name: name,
      address: address,
      description: description,
      price: price,
      hours: hours,
      policies: policies,
      basePriceValue: basePriceValue,
      basePriceUnit: unit,
      extraPrices: extraPrices,
      location: loc,
      workingHours: wh,
      policySections: ps,
      amenities: am,
      images: images,
      hidden: hidden,
      totalSeats: totalSeats,
      adminId: adminId,
      adminName: adminName,
      paymentMethods: paymentMethods,
    );
  }

  static SpaceFormModel fromEntity(SpaceFormEntity e) {
    final loc = e.location == null
        ? null
        : SpaceLocationModel.fromEntity(e.location!).toJson();

    return SpaceFormModel(
      id: e.id,
      name: e.name,
      address: e.address,
      description: e.description,
      price: e.price,
      hours: e.hours,
      policies: e.policies,
      basePriceValue: e.basePriceValue,
      basePriceUnit: PriceUnitModel.toJson(e.basePriceUnit),
      location: loc,
      workingHours: e.workingHours
          .map((x) => WorkingHoursModel.fromEntity(x).toJson())
          .toList(growable: false),
      policySections: e.policySections
          .map((x) => PolicySectionModel.fromEntity(x).toJson())
          .toList(growable: false),
      amenities: e.amenities
          .map((x) => AmenityModel.fromEntity(x).toJson())
          .toList(growable: false),
      images: e.images,
      hidden: e.hidden,
      totalSeats: e.totalSeats,
      adminId: e.adminId,
      adminName: e.adminName,
      paymentMethods: e.paymentMethods,
      extraPrices: e.extraPrices,
    );
  }


  /// 🔥 helper تحويل String → Enum
 static PriceUnit _unitFromString(String? unit) {
    switch (unit) {
      case 'week':
        return PriceUnit.week;
      case 'month':
        return PriceUnit.month;
      default:
        return PriceUnit.day;
    }
  }
}