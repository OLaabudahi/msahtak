import 'package:equatable/equatable.dart';
import '../domain/entities/space_form_entity.dart';

enum AddEditSpaceStatus { initial, loading, ready, saving, saved, failure }

class AddEditSpaceState extends Equatable {
  final AddEditSpaceStatus status;
  final SpaceFormEntity? form;
  final bool amenityCatalogLoading;
  final String? error;

  // Validation errors
  final String? nameError;
  final String? addressError;
  final String? basePriceError;
  final String? workingHoursError;
  final String? policiesError;

  const AddEditSpaceState({
    required this.status,
    required this.form,
    required this.amenityCatalogLoading,
    required this.error,
    required this.nameError,
    required this.addressError,
    required this.basePriceError,
    required this.workingHoursError,
    required this.policiesError,
  });

  factory AddEditSpaceState.initial() => const AddEditSpaceState(
        status: AddEditSpaceStatus.initial,
        form: null,
        amenityCatalogLoading: false,
        error: null,
        nameError: null,
        addressError: null,
        basePriceError: null,
        workingHoursError: null,
        policiesError: null,
      );

  AddEditSpaceState copyWith({
    AddEditSpaceStatus? status,
    SpaceFormEntity? form,
    bool? amenityCatalogLoading,
    String? error,
    String? nameError,
    String? addressError,
    String? basePriceError,
    String? workingHoursError,
    String? policiesError,
    bool clearNameError = false,
    bool clearAddressError = false,
    bool clearBasePriceError = false,
    bool clearWorkingHoursError = false,
    bool clearPoliciesError = false,
  }) {
    return AddEditSpaceState(
      status: status ?? this.status,
      form: form ?? this.form,
      amenityCatalogLoading: amenityCatalogLoading ?? this.amenityCatalogLoading,
      error: error,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      addressError: clearAddressError ? null : (addressError ?? this.addressError),
      basePriceError: clearBasePriceError ? null : (basePriceError ?? this.basePriceError),
      workingHoursError: clearWorkingHoursError ? null : (workingHoursError ?? this.workingHoursError),
      policiesError: clearPoliciesError ? null : (policiesError ?? this.policiesError),
    );
  }

  @override
  List<Object?> get props => [
        status,
        form,
        amenityCatalogLoading,
        error,
        nameError,
        addressError,
        basePriceError,
        workingHoursError,
        policiesError,
      ];
}
