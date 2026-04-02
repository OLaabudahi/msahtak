import '../../data/models/space_details_model.dart';

abstract class SpaceDetailsRepo {
  /// âœ… ط¯ط§ظ„ط©: طھط¬ظٹط¨ طھظپط§طµظٹظ„ ط§ظ„ظ…ط³ط§ط­ط© ط­ط³ط¨ ط§ظ„ظ€ id
  Future<SpaceDetails> fetchSpaceDetails(String spaceId);

}


