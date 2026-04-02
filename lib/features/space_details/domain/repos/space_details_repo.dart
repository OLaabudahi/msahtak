import '../../data/models/space_details_model.dart';

abstract class SpaceDetailsRepo {
  
  Future<SpaceDetails> fetchSpaceDetails(String spaceId);

}
