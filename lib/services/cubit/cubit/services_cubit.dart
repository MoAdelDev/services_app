import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entertainment_services/add/service_model.dart';
import 'package:url_launcher/url_launcher.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesLoading());
  List<ServiceModel> services = [];
  String categoryTitle = '';
  void getServices(String categoryId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .get();
      categoryTitle = result.data()!['title'];
      FirebaseFirestore.instance
          .collection('services')
          .where('category', isEqualTo: categoryId)
          .snapshots()
          .listen((event) {
        services =
            event.docs.map((e) => ServiceModel.fromJson(e.data())).toList();
        emit(ServicesLoaded(services: services));
      }).onError((error) {
        emit(ServicesError(message: error.toString()));
      });
    } catch (e) {
      emit(ServicesError(message: e.toString()));
    }
  }

  void searchServiceByTitleOrAddress(String query) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('title',
              isGreaterThanOrEqualTo: query, isLessThan: getNextString(query))
          .get();

      var addressSnapshot = await FirebaseFirestore.instance
          .collection('services')
          .where('address',
              isGreaterThanOrEqualTo: query, isLessThan: getNextString(query))
          .get();

      services = {...querySnapshot.docs, ...addressSnapshot.docs}
          .map((e) => ServiceModel.fromJson(e.data()))
          .toList();

      emit(ServicesLoaded(services: services));
    } on FirebaseException catch (error) {
      emit(ServicesError(message: error.toString()));
    } catch (e) {
      emit(ServicesError(message: e.toString()));
    }
  }

  void deleteService(String id) async {
    try {
      await FirebaseFirestore.instance.collection('services').doc(id).delete();
      emit(ServicesDeleteSuccess());
    } on FirebaseException catch (error) {
      emit(ServicesDeleteError(message: error.toString()));
    }
  }

  String getNextString(String query) {
    return query.substring(0, query.length - 1) +
        String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);
  }

  Future<void> openMap(double latitude, double longitude) async {
    Uri googleMapsUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    try {
      if (!await launchUrl(googleMapsUri)) {
        throw Exception('Could not launch $googleMapsUri');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
