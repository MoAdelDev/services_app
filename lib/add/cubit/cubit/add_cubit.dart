import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainment_services/add/add_screen.dart';
import 'package:entertainment_services/add/service_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
part 'add_state.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit() : super(AddInitial());

  File? imageFile;

  void uploadImage() async {
    ImagePicker picker = ImagePicker();
    final response = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (response == null) return;
    imageFile = File(response.path);
    emit(UploadImage());
  }

  final formKey = GlobalKey<FormState>();

  void addService({
    required LocationSelection locationSelection,
    required String latitude,
    required String longitude,
    required String title,
    required String description,
    required String category,
  }) async {
    if (formKey.currentState!.validate() && imageFile != null) {
      emit(AddLoading());
      Position? position;
      if (locationSelection == LocationSelection.currentPosition) {
        position = await getCurrentPosition();
      }
      try {
        var placeMarkers = await placemarkFromCoordinates(
          position?.latitude ?? double.parse(latitude),
          position?.longitude ?? double.parse(longitude),
        );
        Placemark place = placeMarkers[0];
        String fullAddress =
            '${place.country}, ${place.street}, ${place.name}, ${place.subLocality}';
        String id = DateTime.now().millisecondsSinceEpoch.toString();

        FirebaseStorage.instance
            .ref()
            .child('services/$id')
            .putFile(imageFile!)
            .then((p0) {
          p0.ref.getDownloadURL().then((value) {
            ServiceModel serviceModel = ServiceModel(
              title: title,
              description: description,
              category: category,
              latitude: position?.latitude ?? double.parse(latitude),
              longitude: position?.longitude ?? double.parse(longitude),
              image: value,
              address: fullAddress,
              id: id,
            );
            FirebaseFirestore.instance
                .collection('services')
                .doc(id)
                .set(serviceModel.toJson())
                .then((value) {
              imageFile = null;
              emit(AddSuccess());
            }).catchError((e) {
              emit(AddError(e.toString()));
            });
          });
        }).catchError((error) {
          emit(AddError(error.toString()));
        });
      } catch (e) {
        emit(AddError('أدخل بيانات صحيحة'));
      }
    } else {
      emit(AddError('ادخل جميع البيانات'));
    }
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return await Geolocator.getCurrentPosition();
  }
}
