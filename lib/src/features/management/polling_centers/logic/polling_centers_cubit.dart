import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import '../../../voter/models/voter_model.dart';
import '../../../../core/services/voter_service.dart';

part 'polling_centers_state.dart';

@injectable
class PollingCentersCubit extends Cubit<PollingCentersState> {
  final VoterService _voterService;

  PollingCentersCubit(this._voterService) : super(PollingCentersInitial());

  List<PollingCenterModel> _pollingCenters = [];
  List<PollingCenterModel> get pollingCenters => _pollingCenters;

  Future<void> fetchPollingCenters({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(PollingCentersLoading());
    }

    try {
      final result = await _voterService.getPollingCenters();

      if (result.isSuccess && result.data != null) {
        _pollingCenters = result.data!;
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

  void filterPollingCenters(String query) {
    if (query.isEmpty) {
      emit(PollingCentersLoaded(pollingCenters: _pollingCenters));
    } else {
      final filteredCenters = _pollingCenters.where((center) {
        return center.name.toLowerCase().contains(query.toLowerCase()) ||
            center.address.toLowerCase().contains(query.toLowerCase()) ||
            center.actualName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(PollingCentersLoaded(pollingCenters: filteredCenters));
    }
  }

  void resetToAllCenters() {
    emit(PollingCentersLoaded(pollingCenters: _pollingCenters));
  }
}
