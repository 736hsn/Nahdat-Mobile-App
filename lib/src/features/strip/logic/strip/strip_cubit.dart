import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/src/core/api/endpoints.dart';
import 'package:supervisor/src/core/api/dio_consumer.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';
import 'package:supervisor/src/features/strip/models/strip_model.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'dart:io';

part 'strip_state.dart';

@injectable
class StripCubit extends Cubit<StripState> {
  final DioConsumer _dioConsumer = getIt<DioConsumer>();

  StripCubit() : super(StripInitial());

  List<StripModel> _strips = [];
  List<StripModel> get strips => _strips;

  // Fetch all strips
  Future<void> fetchStrips({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(StripLoading());
    }

    try {
      final result = await _dioConsumer.get(endpoint: EndPoints.strip);

      if (result.data != null) {
        // Debug: Print the raw response to see structure
        print('Raw API Response: ${result.data}');
        print('Response Type: ${result.data.runtimeType}');

        // Handle pagination response structure
        dynamic responseData =
            result.data?.data; // Access the actual response data
        print('Response Data: $responseData');
        print('Response Data Type: ${responseData.runtimeType}');

        List<dynamic> strips;

        if (responseData is Map && responseData.containsKey('data')) {
          // API returns pagination format with 'data' field containing the strips array
          strips = List<dynamic>.from(responseData['data']);
          print('Using pagination format - strips count: ${strips.length}');
        } else if (responseData is List) {
          // Direct array response
          strips = responseData;
          print('Using direct array - strips count: ${strips.length}');
        } else {
          strips = [];
          print('No strips found - using empty array');
        }

        print('Strips raw data: $strips');
        _strips = strips.map((item) => StripModel.fromJson(item)).toList();
        print('Parsed strips count: ${_strips.length}');
        emit(StripLoaded(strips: _strips));
      } else {
        print('Result.data is null');
        emit(StripError(message: "فشل في تحميل الشرائط"));
      }
    } catch (e) {
      print('Error in fetchStrips: $e');
      emit(StripError(message: e.toString()));
    }
  }

  // Add new strip
  Future<void> addStrip({
    required int pollingCenterId,
    required List<File> images,
  }) async {
    try {
      emit(StripAddLoading());

      // Prepare form data
      final Map<String, String> fields = {
        'polling_center_id': pollingCenterId.toString(),
      };

      // Convert File to MultipartFile
      final List<MultipartFile> multipartImages = [];
      for (File image in images) {
        final multipartFile = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
        multipartImages.add(multipartFile);
      }

      final Map<String, List<MultipartFile>> fileSections = {
        'images[]': multipartImages,
      };

      final result = await _dioConsumer.multipartPost(
        endpoint: "strip_image",
        fields: fields,
        fileSections: fileSections,
      );

      if (result.data != null) {
        emit(StripAddSuccess(message: "تم إضافة الشريط بنجاح"));
        // Refresh strips list
        await fetchStrips();
      } else {
        emit(StripAddError(message: "فشل في إضافة الشريط"));
      }
    } catch (e) {
      emit(StripAddError(message: e.toString()));
    }
  }

  // Update existing strip
  Future<void> updateStrip({
    required int id,
    required int pollingCenterId,
    List<File>? newImages,
  }) async {
    try {
      emit(StripUpdateLoading());

      if (newImages != null && newImages.isNotEmpty) {
        // If there are new images, use multipart update
        final Map<String, String> fields = {
          'polling_center_id': pollingCenterId.toString(),
        };

        // Convert File to MultipartFile
        final List<MultipartFile> multipartImages = [];
        for (File image in newImages) {
          final multipartFile = await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          );
          multipartImages.add(multipartFile);
        }

        final Map<String, List<MultipartFile>> fileSections = {
          'images[]': multipartImages,
        };

        final result = await _dioConsumer.multipartPost(
          endpoint: "strip_image/$id",
          fields: fields,
          fileSections: fileSections,
        );

        if (result.data != null) {
          emit(StripUpdateSuccess(message: "تم تحديث الشريط بنجاح"));
          await fetchStrips();
        } else {
          emit(StripUpdateError(message: "فشل في تحديث الشريط"));
        }
      } else {
        // If no new images, use regular PUT request
        final result = await _dioConsumer.put(
          endpoint: "strip_image/$id",
          body: {'polling_center_id': pollingCenterId},
        );

        if (result.data != null) {
          emit(StripUpdateSuccess(message: "تم تحديث الشريط بنجاح"));
          await fetchStrips();
        } else {
          emit(StripUpdateError(message: "فشل في تحديث الشريط"));
        }
      }
    } catch (e) {
      emit(StripUpdateError(message: e.toString()));
    }
  }

  // Delete strip
  Future<void> deleteStrip(int id) async {
    try {
      emit(StripDeleteLoading());

      final result = await _dioConsumer.delete(endpoint: "strip_image/$id");

      if (result.data != null) {
        emit(StripDeleteSuccess(message: "تم حذف الشريط بنجاح"));
        await fetchStrips();
      } else {
        emit(StripDeleteError(message: "فشل في حذف الشريط"));
      }
    } catch (e) {
      emit(StripDeleteError(message: e.toString()));
    }
  }

  // Search functionality (existing)
  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      emit(StripSearchEmpty());
      return;
    }

    emit(StripSearchLoading());

    try {
      final result = await _dioConsumer.get(endpoint: "search?search=$query");

      if (result.data != null) {
        dynamic data = result.data!.data;
        List<dynamic> searchData;

        if (data is List) {
          searchData = data;
        } else if (data is Map && data.containsKey('results')) {
          searchData = List<dynamic>.from(data['results']);
        } else {
          searchData = [];
        }

        final searchResults = searchData
            .map((item) => SearchResult.fromJson(item))
            .toList();

        if (searchResults.isEmpty) {
          emit(StripSearchNoResults());
        } else {
          emit(StripSearchSuccess(results: searchResults));
        }
      } else {
        emit(StripSearchError(message: "فشل في البحث"));
      }
    } catch (e) {
      emit(StripSearchError(message: e.toString()));
    }
  }

  void clearSearch() {
    emit(StripInitial());
  }
}

class SearchResult {
  final int id;
  final String title;
  final String type;

  SearchResult({required this.id, required this.title, required this.type});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
