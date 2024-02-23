import 'package:entertainment_services/add/cubit/cubit/add_cubit.dart';
import 'package:entertainment_services/core/widgets/default_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LocationSelection { currentPosition, manual }

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String category = '1';
  LocationSelection _locationSelection = LocationSelection.currentPosition;

  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCubit(),
      child: BlocConsumer<AddCubit, AddState>(
        listener: (context, state) {
          if (state is AddSuccess) {
            _titleController.text = '';
            _descriptionController.text = '';
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('تم الاضافة بنجاح'),
            ));
          }

          if (state is AddError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
            ));
          }
        },
        builder: (context, state) {
          AddCubit cubit = context.read<AddCubit>();
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('إضافة خدمة'),
                actions: [
                  state is AddLoading
                      ? const DefaultProgressIndicator()
                      : TextButton(
                          onPressed: () => cubit.addService(
                            locationSelection: _locationSelection,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            category: category,
                            latitude: _latitudeController.text,
                            longitude: _longitudeController.text,
                          ),
                          child: const Text(
                            'إضافة',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => cubit.uploadImage(),
                      child: Container(
                        width: double.infinity,
                        height: 300.0,
                        color: Colors.grey.shade400,
                        child: cubit.imageFile == null
                            ? Icon(
                                Icons.photo,
                                size: 100.0,
                                color: Colors.grey.shade800,
                              )
                            : Image.file(
                                cubit.imageFile!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                hintText: 'عنوان الخدمة',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'ادخل عنوان الخدمة';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                hintText: 'وصف الخدمة',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'ادخل وصف الخدمة';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            DropdownMenu(
                              label: const Text('الأقسام'),
                              onSelected: (value) {
                                setState(() {
                                  category = value ?? '';
                                });
                              },
                              initialSelection: category,
                              dropdownMenuEntries: const [
                                DropdownMenuEntry(
                                  value: '1',
                                  label: 'الأماكن الترفيهية',
                                ),
                                DropdownMenuEntry(
                                  value: '2',
                                  label: 'المصالح الحكومية',
                                ),
                                DropdownMenuEntry(
                                  value: '3',
                                  label: 'المرافق العامة',
                                ),
                              ],
                            ),

                            ListTile(
                              title: const Text('أستخدم موقعك الحالي'),
                              leading: Radio<LocationSelection>(
                                value: LocationSelection.currentPosition,
                                groupValue: _locationSelection,
                                onChanged: (LocationSelection? value) {
                                  setState(() {
                                    _locationSelection = value!;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('باستخدام الإحداثيات'),
                              leading: Radio<LocationSelection>(
                                value: LocationSelection.manual,
                                groupValue: _locationSelection,
                                onChanged: (LocationSelection? value) {
                                  setState(() {
                                    _locationSelection = value!;
                                  });
                                },
                              ),
                            ),

                            // Latitude and Longitude fields
                            if (_locationSelection ==
                                LocationSelection.manual) ...[
                              TextFormField(
                                controller: _latitudeController,
                                decoration: const InputDecoration(
                                  hintText: 'Latitude',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (_locationSelection ==
                                      LocationSelection.manual) {
                                    if (value == null || value.isEmpty) {
                                      return 'ادخل latitude';
                                    }
                                    return null;
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _longitudeController,
                                decoration: const InputDecoration(
                                  hintText: 'Longitude',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (_locationSelection ==
                                      LocationSelection.manual) {
                                    if (value == null || value.isEmpty) {
                                      return 'ادخل longitude';
                                    }
                                    return null;
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
