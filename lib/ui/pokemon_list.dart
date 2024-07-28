import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_pikotea/bloc/pokemon_bloc.dart';
import 'package:poke_pikotea/bloc/pokemon_event.dart';
import 'package:poke_pikotea/bloc/pokemon_state.dart';
import 'package:poke_pikotea/ui/pokemon_details.dart';
import 'package:poke_pikotea/ui/widgets/texto_ambar.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      context.read<PokemonBloc>().add(FetchPokemons(
            offset: context.read<PokemonBloc>().state.pokemons.length,
            limit: 20,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextoAmbar(texto: 'Poketea'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(color: Colors.amber),
                decoration: const InputDecoration(
                  labelText: 'Buscar Pokémon',
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber)),
                ),
                onTapOutside: (event) {},
                onChanged: (query) {
                  context.read<PokemonBloc>().add(FilterPokemons(query: query));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextoAmbar(texto: 'Mostrar favoritos'),
                  Switch(
                    activeColor: Colors.amber,
                    value: context.watch<PokemonBloc>().state.showFavorites,
                    onChanged: (value) {
                      context.read<PokemonBloc>().add(FilterPokemons(
                            query:
                                context.read<PokemonBloc>().state.filterQuery,
                            showFavorites: value,
                          ));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<PokemonBloc, PokemonState>(
                builder: (context, state) {
                  if (state.isLoading && state.pokemons.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.filteredPokemons.isEmpty) {
                    return const Center(child: Text('No Pokémons found'));
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.hasReachedMax
                          ? state.filteredPokemons.length
                          : state.filteredPokemons.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.filteredPokemons.length) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.amber,
                          ));
                        }
                        final pokemon = state.filteredPokemons[index];
                        return ListTile(
                          leading: Image.network(pokemon.image!),
                          title: Text(
                            pokemon.name!,
                            style: const TextStyle(color: Colors.amber),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              color: Colors.amber,
                              state.favorites.contains(pokemon)
                                  ? Icons.star
                                  : Icons.star_border,
                            ),
                            onPressed: () {
                              context
                                  .read<PokemonBloc>()
                                  .add(ToggleFavorite(pokemon));
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PokemonDetail(pokemon: pokemon),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
