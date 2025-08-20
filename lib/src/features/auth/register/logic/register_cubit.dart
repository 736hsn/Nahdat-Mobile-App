import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_consumer.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/common/models/result.dart';
import 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final DioConsumer _dioConsumer = DioConsumer();

  RegisterCubit() : super(RegisterInitial());

  Future<void> register({
    required String firstName,
    required String secondName,
    required String thirdName,
    required String phone,
    String? yearOfBirth,
    required File cardImage,
    File? imagePath,
    required String isCardUpdated,
    required String pollingCenterId,
  }) async {
    try {
      emit(RegisterLoading());

      // Prepare fields map
      Map<String, String> fields = {
        'first_name': firstName,
        'second_name': secondName,
        'third_name': thirdName,
        'phone': phone,
        'year_of_birth': yearOfBirth ?? '',
        'is_card_updated': isCardUpdated,
        'polling_center_id': pollingCenterId,
      };

      // Prepare files map
      Map<String, List<MultipartFile>> fileSections = {
        'card_image': [await MultipartFile.fromFile(cardImage.path)],
      };

      // Add image_path if provided
      if (imagePath != null) {
        fileSections['image_path'] = [
          await MultipartFile.fromFile(imagePath.path),
        ];
      }

      final Result<Response> result = await _dioConsumer.multipartPost(
        endpoint: EndPoints.register,
        fields: fields,
        fileSections: fileSections,
      );

      if (result.isSuccess) {
        log('Registered successfully :${result.data?.data?['message']}');
        emit(
          RegisterSuccess(
            result.data?.data?['message'] ?? 'تم إنشاء الحساب بنجاح',
          ),
        );
      } else {
        log('Register failed :${result.error}');

        emit(RegisterError(result.error ?? 'فشل في إنشاء الحساب'));
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
