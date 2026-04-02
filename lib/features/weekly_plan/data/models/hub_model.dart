import '../../domain/entities/hub.dart';

class HubModel extends Hub {
  const HubModel({required super.id, required super.name});

  factory HubModel.fromJson(Map<String, dynamic> json) =>
      HubModel(id: json['id'] as String, name: json['name'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}


