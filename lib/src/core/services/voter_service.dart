import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../api/dio_consumer.dart';
import '../api/endpoints.dart';
import '../common/models/result.dart';
import '../../features/voter/models/voter_model.dart';

@injectable
class VoterService {
  final DioConsumer _dioConsumer;

  VoterService(this._dioConsumer);

  Future<Result<VoterResponse>> getVoters({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final result = await _dioConsumer.get(
        // endpoint: '${EndPoints.voter}?page=$page&per_page=$perPage',
        endpoint: '${EndPoints.voter}',
      );

      if (result.isSuccess && result.data != null) {
        final voterResponse = VoterResponse.fromJson(result.data!.data);
        return Result(data: voterResponse);
      } else {
        return Result(error: result.error ?? 'Failed to fetch voters');
      }
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<VoterModel>> getVoterById(int id) async {
    try {
      final result = await _dioConsumer.get(endpoint: '${EndPoints.voter}/$id');

      if (result.isSuccess && result.data != null) {
        final voter = VoterModel.fromJson(result.data!.data);
        return Result(data: voter);
      } else {
        return Result(error: result.error ?? 'Failed to fetch voter');
      }
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<VoterModel>> updateVoter(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _dioConsumer.put(
        endpoint: '${EndPoints.voter}/$id',
        body: data,
      );

      if (result.isSuccess && result.data != null) {
        final voter = VoterModel.fromJson(result.data!.data);
        return Result(data: voter);
      } else {
        return Result(error: result.error ?? 'Failed to update voter');
      }
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<VoterModel>> createVoter({
    required String firstName,
    required String secondName,
    required String thirdName,
    required String phone,
    String? yearOfBirth,
    required MultipartFile cardImage,
    MultipartFile? imagePath,
    required String isCardUpdated,
    required String pollingCenterId,
  }) async {
    try {
      Map<String, String> fields = {
        'first_name': firstName,
        'second_name': secondName,
        'third_name': thirdName,
        'phone': phone,
        'year_of_birth': yearOfBirth ?? '',
        'is_card_updated': isCardUpdated,
        'polling_center_id': pollingCenterId,
      };

      Map<String, List<MultipartFile>> fileSections = {
        'card_image': [cardImage],
      };

      if (imagePath != null) {
        fileSections['image_path'] = [imagePath];
      }

      final result = await _dioConsumer.multipartPost(
        endpoint: EndPoints.voter,
        fields: fields,
        fileSections: fileSections,
      );

      if (result.isSuccess && result.data != null) {
        final voter = VoterModel.fromJson(result.data!.data);
        return Result(data: voter);
      } else {
        return Result(error: result.error ?? 'Failed to create voter');
      }
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<List<PollingCenterModel>>> getPollingCenters() async {
    try {
      final result = await _dioConsumer.get(endpoint: EndPoints.pollingCenter);

      if (result.isSuccess && result.data != null) {
        final List<dynamic> centersList = result.data!.data['data'] ?? [];
        final centers = centersList
            .map((center) => PollingCenterModel.fromJson(center))
            .toList();
        return Result(data: centers);
      } else {
        return Result(error: result.error ?? 'Failed to fetch polling centers');
      }
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> markVoterAsVoted(int voterId) async {
    try {
      final result = await _dioConsumer.post(
        endpoint: EndPoints.voterVoting,
        body: {'voter_id': voterId},
      );

      if (result.isSuccess) {
        return Result(data: true);
      } else {
        return Result(error: result.error ?? 'Failed to mark voter as voted');
      }
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}

class VoterResponse {
  final List<VoterModel> data;
  final VoterMeta meta;

  VoterResponse({required this.data, required this.meta});

  factory VoterResponse.fromJson(Map<String, dynamic> json) {
    return VoterResponse(
      data: (json['data'] as List? ?? [])
          .map((item) => VoterModel.fromJson(item))
          .toList(),
      meta: VoterMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class VoterMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasNextPage;
  final bool hasPreviousPage;

  VoterMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory VoterMeta.fromJson(Map<String, dynamic> json) {
    return VoterMeta(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      hasNextPage: json['has_next_page'] ?? false,
      hasPreviousPage: json['has_previous_page'] ?? false,
    );
  }
}
