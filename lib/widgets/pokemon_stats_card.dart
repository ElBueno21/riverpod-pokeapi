import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_pokeapi/providers/pokemon_data_providers.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonURL;

  const PokemonStatsCard({
    super.key,
    required this.pokemonURL,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(
      pokemonDataProvider(
        pokemonURL,
      ),
    );

    return AlertDialog(
      title: const Text("Stats"),
      content: pokemon.when(data: (data) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: data?.stats?.map((s) {
                return Text("${s.stat?.name?.toUpperCase()}: ${s.baseStat}");
              }).toList() ??
              [],
        );
      }, error: (error, stackTrace) {
        return Text("Error: $error");
      }, loading: () {
        return const CircularProgressIndicator();
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
