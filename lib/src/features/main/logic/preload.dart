import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreloadService {
  Future<void> preloadData(BuildContext context) async {
    final reads = context.read;

    // reads<PriceCubit>().fetchPrices();
    // reads<GovernoratesCubit>().fetchGovernorates();
    // reads<CategoryCubit>().fetchCategories();
  }
}
