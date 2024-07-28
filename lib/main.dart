import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_pikotea/bloc/pokemon_event.dart';
import 'bloc/pokemon_bloc.dart';
import 'repositories/pokemon_repository.dart';
import 'ui/pokemon_list.dart';

void main() {
  final PokemonRepository repository = PokemonRepository();
  runApp(PokedexApp(repository: repository));
}

class PokedexApp extends StatelessWidget {
  final PokemonRepository repository;

  const PokedexApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PokemonBloc(repository)..add(FetchPokemons()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Poketea',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const PokemonList(),
      ),
    );
  }
}
