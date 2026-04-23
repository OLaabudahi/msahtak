import 'package:equatable/equatable.dart';

class FaqItemEntity extends Equatable {
  final String questionAr;
  final String questionEn;
  final String answerAr;
  final String answerEn;
  final int order;

  const FaqItemEntity({
    required this.questionAr,
    required this.questionEn,
    required this.answerAr,
    required this.answerEn,
    required this.order,
  });

  @override
  List<Object?> get props => [questionAr, questionEn, answerAr, answerEn, order];
}

class AboutContentEntity extends Equatable {
  final List<String> appInfoAr;
  final List<String> appInfoEn;
  final List<String> policiesAr;
  final List<String> policiesEn;

  const AboutContentEntity({
    required this.appInfoAr,
    required this.appInfoEn,
    required this.policiesAr,
    required this.policiesEn,
  });

  @override
  List<Object?> get props => [appInfoAr, appInfoEn, policiesAr, policiesEn];
}
