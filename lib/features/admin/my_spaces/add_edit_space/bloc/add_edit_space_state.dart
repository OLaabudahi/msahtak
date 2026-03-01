import 'package:equatable/equatable.dart';
import '../domain/entities/space_form_entity.dart';

enum AddEditSpaceStatus { initial, loading, ready, saving, saved, failure }

class AddEditSpaceState extends Equatable {
  final AddEditSpaceStatus status;
  final SpaceFormEntity? form;
  final String? error;

  const AddEditSpaceState({
    required this.status,
    required this.form,
    required this.error,
  });

  factory AddEditSpaceState.initial() => const AddEditSpaceState(status: AddEditSpaceStatus.initial, form: null, error: null);

  AddEditSpaceState copyWith({AddEditSpaceStatus? status, SpaceFormEntity? form, String? error}) {
    return AddEditSpaceState(status: status ?? this.status, form: form ?? this.form, error: error);
  }

  @override
  List<Object?> get props => [status, form, error];
}
