import '../entities/help_content_entity.dart';

abstract class HelpContentRepo {
  Future<List<FaqItemEntity>> getFaqItems();
  Future<AboutContentEntity?> getAboutContent();
}
