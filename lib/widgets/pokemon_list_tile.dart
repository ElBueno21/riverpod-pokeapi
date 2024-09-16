import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_pokeapi/models/pokemon.dart';
import 'package:riverpod_pokeapi/providers/pokemon_data_providers.dart';
import 'package:riverpod_pokeapi/widgets/pokemon_stats_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  late FavoritePokemonProvider _favoritePokemonProvider;
  late List<String> _favoritePokemon;

  PokemonListTile({
    super.key,
    required this.pokemonURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonProvider = ref.watch(
      favoritePokemonProvider.notifier,
    );
    _favoritePokemon = ref.watch(
      favoritePokemonProvider,
    );
    final pokemon = ref.watch(
      pokemonDataProvider(
        pokemonURL,
      ),
    );
    return pokemon.when(
      data: (data) {
        return _tile(context, false, data);
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
      loading: () {
        return _tile(context, true, null);
      },
    );
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
                context: context,
                builder: (_) {
                  return PokemonStatsCard(pokemonURL: pokemonURL);
                });
          }
        },
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    pokemon.sprites?.frontDefault ?? '',
                  ),
                )
              : const CircleAvatar(),
          title: Text(
            pokemon != null
                ? pokemon.name!.toUpperCase()
                : 'Currenly loading name for Pokemon',
          ),
          subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
          trailing: IconButton(
            onPressed: () {
              if (_favoritePokemon.contains(pokemonURL)) {
                _favoritePokemonProvider.removeFavoritePokemon(pokemonURL);
              } else {
                _favoritePokemonProvider.addFavoritePokemon(pokemonURL);
              }
            },
            icon: Icon(
              _favoritePokemon.contains(pokemonURL)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
