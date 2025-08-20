import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import '../models/voter_model.dart';
import '../../../core/services/voter_service.dart';

part 'add_voter_state.dart';

@injectable
class AddVoterCubit extends Cubit<AddVoterState> {
  final VoterService _voterService;

  AddVoterCubit(this._voterService) : super(AddVoterInitial());

  List<PollingCenterModel> _pollingCenters = [];
  List<PollingCenterModel> get pollingCenters => _pollingCenters;

  Future<void> fetchPollingCenters() async {
    print('------fetchPollingCenters----');
    try {
      emit(PollingCentersLoading());

      final result = await _voterService.getPollingCenters();

      if (result.isSuccess && result.data != null) {
        print('------fetchPollingCenters----success');

        _pollingCenters = result.data!;
        print('------fetchPollingCenters----${_pollingCenters.length}');
        emit(PollingCentersLoaded(pollingCenters: _pollingCenters));
      } else {
        emit(
          PollingCentersError(
            error: result.error ?? 'فشل في تحميل مراكز الاقتراع',
          ),
        );
      }
    } catch (e) {
      emit(PollingCentersError(error: e.toString()));
    }
  }

  Future<void> createVoter({
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
      emit(AddVoterLoading(pollingCenters: _pollingCenters));

      final cardImageFile = await MultipartFile.fromFile(cardImage.path);
      MultipartFile? imagePathFile;
      if (imagePath != null) {
        imagePathFile = await MultipartFile.fromFile(imagePath.path);
      }

      final result = await _voterService.createVoter(
        firstName: firstName,
        secondName: secondName,
        thirdName: thirdName,
        phone: phone,
        yearOfBirth: yearOfBirth,
        cardImage: cardImageFile,
        imagePath: imagePathFile,
        isCardUpdated: isCardUpdated,
        pollingCenterId: pollingCenterId,
      );

      if (result.isSuccess && result.data != null) {
        emit(AddVoterSuccess(voter: result.data!));
      } else {
        emit(
          AddVoterError(
            error: result.error ?? 'فشل في إضافة عضو',
            pollingCenters: _pollingCenters,
          ),
        );
      }
    } catch (e) {
      emit(AddVoterError(error: e.toString(), pollingCenters: _pollingCenters));
    }
  }

  void resetState() {
    if (_pollingCenters.isNotEmpty) {
      emit(PollingCentersLoaded(pollingCenters: _pollingCenters));
    } else {
      emit(AddVoterInitial());
    }
  }
}
