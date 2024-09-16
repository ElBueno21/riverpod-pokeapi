import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_pokeapi/models/pokemon.dart';
import 'package:riverpod_pokeapi/services/database_service.dart';
import 'package:riverpod_pokeapi/services/http_services.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpServices httpServices = GetIt.instance.get<HttpServices>();
  Response? res = await httpServices.get(url);
  if (res != null && res.data != null) {
    Pokemon data = Pokemon.fromJson(res.data);
    return data;
  }
  return null;
});

final favoritePokemonProvider =
    StateNotifierProvider<FavoritePokemonProvider, List<String>>(
  (ref) {
    return FavoritePokemonProvider(
      [],
    );
  },
);

class FavoritePokemonProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();

  final String FAVORITE_POKEMON_LIST_KEY = 'FAVORITE_POKEMON_LIST_KEY';

  FavoritePokemonProvider(
    super._state,
  ) {
    _setup();
  }

  Future<void> _setup() async {
    List<String>? result =
        await _databaseService.getList(FAVORITE_POKEMON_LIST_KEY);

    state = result ?? [];
  }

  void addFavoritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }

  void removeFavoritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVORITE_POKEMON_LIST_KEY, state);
  }
}
