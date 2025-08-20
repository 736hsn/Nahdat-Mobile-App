import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../models/voter_model.dart';
import '../../../core/services/voter_service.dart';
import 'package:injectable/injectable.dart';

part 'voter_state.dart';

@injectable
class VoterCubit extends Cubit<VoterState> {
  final VoterService _voterService;

  VoterCubit(this._voterService) : super(VoterInitial());

  List<VoterModel> _voters = [];
  List<VoterModel> get voters => _voters;

  VoterMeta? _meta;
  VoterMeta? get meta => _meta;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int? _votingInProgress;
  int? get votingInProgress => _votingInProgress;

  Future<void> fetchVoters({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _voters.clear();
      emit(VoterLoading());
    }

    try {
      final result = await _voterService.getVoters(
        page: _currentPage,
        perPage: 10,
      );

      if (result.isSuccess && result.data != null) {
        _meta = result.data!.meta;

        if (isRefresh) {
          _voters = result.data!.data;
        } else {
          _voters.addAll(result.data!.data);
        }

        emit(VoterSuccess(voters: _voters, meta: _meta!));
      } else {
        emit(VoterError(error: result.error ?? 'فشل في تحميل البيانات'));
      }
    } catch (e) {
      emit(VoterError(error: e.toString()));
    }
  }

  Future<void> loadMoreVoters() async {
    if (_isLoadingMore || _meta == null || !_meta!.hasNextPage) return;

    _isLoadingMore = true;
    _currentPage++;
    emit(VoterLoadingMore(voters: _voters, meta: _meta!));

    try {
      final result = await _voterService.getVoters(
        page: _currentPage,
        perPage: 10,
      );

      if (result.isSuccess && result.data != null) {
        _meta = result.data!.meta;
        _voters.addAll(result.data!.data);
        emit(VoterSuccess(voters: _voters, meta: _meta!));
      } else {
        emit(VoterError(error: result.error ?? 'فشل في تحميل المزيد'));
      }
    } catch (e) {
      emit(VoterError(error: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refreshVoters() async {
    await fetchVoters(isRefresh: true);
  }

  Future<void> getVoterById(int id) async {
    emit(VoterLoading());
    try {
      final result = await _voterService.getVoterById(id);

      if (result.isSuccess && result.data != null) {
        emit(VoterDetailSuccess(voter: result.data!));
      } else {
        emit(VoterError(error: result.error ?? 'فشل في تحميل بيانات العضر'));
      }
    } catch (e) {
      emit(VoterError(error: e.toString()));
    }
  }

  Future<void> updateVoter(int id, Map<String, dynamic> data) async {
    emit(VoterLoading());
    try {
      final result = await _voterService.updateVoter(id, data);

      if (result.isSuccess && result.data != null) {
        // Update the voter in the local list
        final index = _voters.indexWhere((voter) => voter.id == id);
        if (index != -1) {
          _voters[index] = result.data!;
        }
        emit(VoterUpdateSuccess(voter: result.data!));
      } else {
        emit(VoterError(error: result.error ?? 'فشل في تحديث بيانات العضر'));
      }
    } catch (e) {
      emit(VoterError(error: e.toString()));
    }
  }

  void addNewVoter(VoterModel voter) {
    _voters.insert(0, voter);
    if (_meta != null) {
      _meta = VoterMeta(
        currentPage: _meta!.currentPage,
        lastPage: _meta!.lastPage,
        perPage: _meta!.perPage,
        total: _meta!.total + 1,
        hasNextPage: _meta!.hasNextPage,
        hasPreviousPage: _meta!.hasPreviousPage,
      );
    }
    emit(VoterSuccess(voters: _voters, meta: _meta!));
  }

  Future<void> markVoterAsVoted(int voterId) async {
    _votingInProgress = voterId;

    try {
      final result = await _voterService.markVoterAsVoted(voterId);

      if (result.isSuccess) {
        // Update the voter's voting status locally
        final voterIndex = _voters.indexWhere((voter) => voter.id == voterId);
        if (voterIndex != -1) {
          final updatedVoter = _voters[voterIndex].copyWith(isVoted: true);
          _voters[voterIndex] = updatedVoter;
        }

        emit(
          VoterVotingSuccess(
            voters: _voters,
            meta: _meta!,
            votedVoterId: voterId,
          ),
        );
      } else {
        emit(
          VoterVotingError(
            error: result.error ?? 'فشل في تسجيل التصويت',
            voterId: voterId,
          ),
        );
      }
    } catch (e) {
      emit(VoterVotingError(error: e.toString(), voterId: voterId));
    } finally {
      _votingInProgress = null;
    }
  }

  // Helper getters
  bool get hasNextPage => _meta?.hasNextPage ?? false;
  bool get hasPreviousPage => _meta?.hasPreviousPage ?? false;
  int get totalVoters => _meta?.total ?? 0;
  int get totalPages => _meta?.lastPage ?? 1;

  // Filter methods
  List<VoterModel> get votedVoters =>
      _voters.where((voter) => voter.isVoted).toList();
  List<VoterModel> get notVotedVoters =>
      _voters.where((voter) => !voter.isVoted).toList();
  List<VoterModel> get activeVoters =>
      _voters.where((voter) => voter.isActive == 1).toList();
  List<VoterModel> get inactiveVoters =>
      _voters.where((voter) => voter.isActive == 0).toList();

  @override
  void dispose() {
    // Clean up resources if needed
  }
}
