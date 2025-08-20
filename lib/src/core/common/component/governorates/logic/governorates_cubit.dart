import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../api/dio_consumer.dart';
import '../../../../api/endpoints.dart';
import '../../../models/governorate_model.dart';
import '../../../models/result.dart';
import 'governorates_state.dart';

class GovernoratesCubit extends Cubit<GovernoratesState> {
  final DioConsumer _dioConsumer = DioConsumer();

  GovernoratesCubit() : super(GovernoratesInitial());

  Future<void> fetchGovernorates() async {
    try {
      emit(FetchGovernoratesLoading());

      final Result<Response> result = await _dioConsumer.get(
        endpoint: EndPoints.posts,
      );

      if (result.isSuccess) {
        final Map<String, dynamic> responseData = result.data?.data;
        final List<dynamic> governoratesJson =
            responseData['data'] as List<dynamic>;

        final List<GovernorateModel> governorates =
            governoratesJson
                .map((json) => GovernorateModel.fromJson(json))
                .toList();

        emit(
          FetchGovernoratesSuccess(
            result.data?.data?['message'] ?? 'governorates fetched',
            governorates,
          ),
        );
        print('Governorates length is : ${governorates.length}');
      } else {
        emit(
          FetchGovernoratesError(
            result.error ?? 'Failed to fetch governorates',
          ),
        );
        print(result.error);
      }
    } catch (e) {
      emit(FetchGovernoratesError(e.toString()));
      print(e.toString());
    }
  }
}
