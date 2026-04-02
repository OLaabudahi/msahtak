import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/i18n/app_i18n.dart';

import '../bloc/space_request_bloc.dart';
import '../bloc/space_request_event.dart';
import '../bloc/space_request_state.dart';

class SpaceRequestPage extends StatefulWidget {
  const SpaceRequestPage({super.key});

  @override
  State<SpaceRequestPage> createState() => _SpaceRequestPageState();
}

class _SpaceRequestPageState extends State<SpaceRequestPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final contactController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  final hoursController = TextEditingController();

  void _clearForm() {
    nameController.clear();
    descController.clear();
    locationController.clear();
    phoneController.clear();
    whatsappController.clear();
    contactController.clear();
    priceController.clear();
    capacityController.clear();
    hoursController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<SpaceRequestBloc, SpaceRequestState>(
            listener: (context, state) {
              if (state is SpaceRequestSuccess) {
                Navigator.of(context).pop(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.t('requestSuccess'))),
                );
                /*    _clearForm();



                context.read<SpaceRequestBloc>().add(ResetSpaceRequestEvent());*/
              }
            },
            builder: (context, state) {
              final isLoading = state is SpaceRequestLoading;

              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 60),

                    // ًں”¹ Title
                    Text(
                      context.t('addSpace'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ًں”¹ Note
                    Text(
                      context.t('spaceRequestNote'),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    _input(context, 'spaceName', nameController),
                    _input(context, 'description', descController),
                    _input(context, 'location', locationController),
                    _phoneInput(context, 'phone', phoneController),
                    _phoneInput(context, 'whatsapp', whatsappController),
                    _input(context, 'contactName', contactController),
                    _numberInput(context, 'pricePD', priceController),
                    _numberInput(context, 'capacity', capacityController),
                    _input(context, 'workingHours', hoursController),

                    const SizedBox(height: 30),

                    // ًں”¥ Button
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) return;

                              final data = {
                                "idRequest": DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                "nameSpace": nameController.text.trim(),
                                "descriptionSpace": descController.text.trim(),
                                "locationDes": locationController.text.trim(),
                                "phoneNo": phoneController.text.trim(),
                                "whatsAppNo": whatsappController.text.trim(),
                                "contactName": contactController.text.trim(),
                                "pricePerDay": double.parse(
                                  priceController.text,
                                ),
                                "capacity": int.parse(capacityController.text),
                                "workingHours": hoursController.text.trim(),
                                "createdAt": DateTime.now(),
                              };

                              context.read<SpaceRequestBloc>().add(
                                SubmitSpaceRequestEvent(data),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isLoading ? Colors.grey : Colors.orange,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  context.t('submit'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // =======================
  // Inputs
  // =======================

  Widget _input(
    BuildContext context,
    String key,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        validator: (v) => v == null || v.isEmpty ? context.t('required') : null,
        decoration: InputDecoration(
          labelText: context.t(key),
          enabledBorder: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _numberInput(
    BuildContext context,
    String key,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (v) {
          if (v == null || v.isEmpty) return context.t('required');
          if (double.tryParse(v) == null) {
            return context.t('invalidNumber');
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: context.t(key),
          enabledBorder: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _phoneInput(
    BuildContext context,
    String key,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        validator: (v) {
          if (v == null || v.isEmpty) return context.t('required');
          if (v.length < 9) return context.t('invalidPhone');
          return null;
        },
        decoration: InputDecoration(
          labelText: context.t(key),
          enabledBorder: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}


