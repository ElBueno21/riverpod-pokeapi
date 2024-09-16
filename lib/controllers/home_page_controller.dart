import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_pokeapi/models/page_data.dart';
import 'package:riverpod_pokeapi/models/pokemon.dart';
import 'package:riverpod_pokeapi/services/http_services.dart';
import 'dart:developer' as developer;

class HomePageController extends StateNotifier<HomePageData> {
  final _getIt = GetIt.instance;

  late HttpServices _httpServices;

  HomePageController(
    super._state,
  ) {
    _httpServices = _getIt.get<HttpServices>();
    _setup();
  }

  Future<void> _setup() async {
    loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? res = await _httpServices.get(
        "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0",
      );
      if (res != null && res.data != null) {
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(
          data: data,
        );
        developer.log(state.data?.results?.first.name ?? '');
      }
    } else {
      if (state.data?.next != null) {
        Response? res = await _httpServices.get(
          state.data!.next!,
        );
        if (res != null && res.data != null) {
          PokemonListData data = PokemonListData.fromJson(res.data!);
          state = state.copyWith(
            data: data.copyWith(
              results: [
                ...?state.data?.results,
                ...?data.results,
              ],
            ),
          );
          developer.log(state.data?.results?.last.name ?? '');
        }
      }
    }
  }
}
