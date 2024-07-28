import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_pikotea/bloc/pokemon_event.dart';
import 'package:poke_pikotea/models/pokemon_list_response_model.dart';
import 'package:poke_pikotea/ui/widgets/texto_ambar.dart';
import '../bloc/pokemon_bloc.dart';

class PokemonDetail extends StatelessWidget {
  final PokemonModel pokemon;

  const PokemonDetail({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final isFavorite =
        context.watch<PokemonBloc>().state.favorites.contains(pokemon);
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name!),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(pokemon.image!),
            const SizedBox(height: 16.0),
            const Text('Abilities',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold)),
            Column(
              children: pokemon.abilities!
                  .map((ability) => TextoAmbar(texto: ability))
                  .toList(),
            ),
            IconButton(
              icon: Icon(isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.amber),
              onPressed: () {
                context.read<PokemonBloc>().add(ToggleFavorite(pokemon));
              },
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 130,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all()),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Height: ${pokemon.height}dm',
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all()),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Weight: ${pokemon.weight} hg',
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
