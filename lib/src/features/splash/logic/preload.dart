import 'dart:developer' as developer;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supervisor/src/features/management/profile/logic/profile/profile_cubit.dart';
import 'package:supervisor/src/features/voter/logic/voter_cubit.dart';

class PreloadService {
  Future<void> preloadData(BuildContext context) async {
    final reads = context.read;
    // await context.read<CategoriesCubit>().fetchCategories();

    _safeCall(() => reads<VoterCubit>().fetchVoters(), "Voters");
    _safeCall(() => reads<ProfileCubit>().fetchProfile(), "Profile");

    // _safeCall(() => reads<CityCubit>().fetchCities(""), "Cities");
  }

  void _safeCall(Function fn, String label) {
    try {
      fn();
      developer.log("✅ Loaded: $label");
    } catch (e, stack) {
      developer.log("❌ Error loading $label", error: e, stackTrace: stack);
    }
  }
}
