import '../models/space_details_model.dart';

abstract class SpaceDetailsRepo {
  /// ✅ دالة: تجيب تفاصيل المساحة حسب الـ id
  Future<SpaceDetails> fetchSpaceDetails(String spaceId);
}
