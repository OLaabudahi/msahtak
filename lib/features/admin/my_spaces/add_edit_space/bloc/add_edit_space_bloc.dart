import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/amenity_entity.dart';
import '../domain/entities/space_form_entity.dart';
import '../domain/usecases/get_space_form_usecase.dart';
import '../domain/usecases/save_space_usecase.dart';
import 'add_edit_space_event.dart';
import 'add_edit_space_state.dart';

class AddEditSpaceBloc extends Bloc<AddEditSpaceEvent, AddEditSpaceState> {
  final GetSpaceFormUseCase getForm;
  final SaveSpaceUseCase save;

  AddEditSpaceBloc({required this.getForm, required this.save}) : super(AddEditSpaceState.initial()) {
    on<AddEditSpaceStarted>(_onStarted);
    on<AddEditSpaceAmenityToggled>(_onAmenity);
    on<AddEditSpaceFieldChanged>(_onField);
    on<AddEditSpaceHiddenToggled>(_onHidden);
    on<AddEditSpaceSavePressed>(_onSave);
  }

  Future<void> _onStarted(AddEditSpaceStarted event, Emitter<AddEditSpaceState> emit) async {
    emit(state.copyWith(status: AddEditSpaceStatus.loading, error: null));
    try {
      final form = await getForm(spaceId: event.spaceId);
      emit(state.copyWith(status: AddEditSpaceStatus.ready, form: form));
    } catch (e) {
      emit(state.copyWith(status: AddEditSpaceStatus.failure, error: e.toString()));
    }
  }

  void _onAmenity(AddEditSpaceAmenityToggled event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;
    final nextAmenities = f.amenities.map((a) {
      if (a.id != event.amenityId) return a;
      return AmenityEntity(id: a.id, name: a.name, selected: !a.selected);
    }).toList(growable: false);

    emit(state.copyWith(
      form: SpaceFormEntity(
        id: f.id,
        name: f.name,
        address: f.address,
        price: f.price,
        description: f.description,
        amenities: nextAmenities,
        hours: f.hours,
        policies: f.policies,
        hidden: f.hidden,
      ),
    ));
  }

  void _onField(AddEditSpaceFieldChanged event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;

    SpaceFormEntity next = f;
    switch (event.field) {
      case 'name':
        next = SpaceFormEntity(id: f.id, name: event.value, address: f.address, price: f.price, description: f.description, amenities: f.amenities, hours: f.hours, policies: f.policies, hidden: f.hidden);
        break;
      case 'address':
        next = SpaceFormEntity(id: f.id, name: f.name, address: event.value, price: f.price, description: f.description, amenities: f.amenities, hours: f.hours, policies: f.policies, hidden: f.hidden);
        break;
      case 'price':
        next = SpaceFormEntity(id: f.id, name: f.name, address: f.address, price: event.value, description: f.description, amenities: f.amenities, hours: f.hours, policies: f.policies, hidden: f.hidden);
        break;
      case 'description':
        next = SpaceFormEntity(id: f.id, name: f.name, address: f.address, price: f.price, description: event.value, amenities: f.amenities, hours: f.hours, policies: f.policies, hidden: f.hidden);
        break;
      case 'hours':
        next = SpaceFormEntity(id: f.id, name: f.name, address: f.address, price: f.price, description: f.description, amenities: f.amenities, hours: event.value, policies: f.policies, hidden: f.hidden);
        break;
      case 'policies':
        next = SpaceFormEntity(id: f.id, name: f.name, address: f.address, price: f.price, description: f.description, amenities: f.amenities, hours: f.hours, policies: event.value, hidden: f.hidden);
        break;
    }

    emit(state.copyWith(form: next));
  }

  void _onHidden(AddEditSpaceHiddenToggled event, Emitter<AddEditSpaceState> emit) {
    final f = state.form;
    if (f == null) return;

    emit(state.copyWith(
      form: SpaceFormEntity(
        id: f.id,
        name: f.name,
        address: f.address,
        price: f.price,
        description: f.description,
        amenities: f.amenities,
        hours: f.hours,
        policies: f.policies,
        hidden: event.hidden,
      ),
    ));
  }

  Future<void> _onSave(AddEditSpaceSavePressed event, Emitter<AddEditSpaceState> emit) async {
    final f = state.form;
    if (f == null) return;
    emit(state.copyWith(status: AddEditSpaceStatus.saving, error: null));
    try {
      await save(form: f);
      emit(state.copyWith(status: AddEditSpaceStatus.saved));
    } catch (e) {
      emit(state.copyWith(status: AddEditSpaceStatus.failure, error: e.toString()));
    }
  }
}
