// Definición de estado
import 'package:poke_pikotea/models/pokemon_list_response_model.dart';

class PokemonState {
  final List<PokemonModel> pokemons;
  final List<PokemonModel> filteredPokemons;
  final List<PokemonModel> favorites;
  final bool isLoading;
  final bool hasReachedMax;
  final String filterQuery;
  final bool showFavorites;

  PokemonState({
    required this.pokemons,
    required this.filteredPokemons,
    required this.favorites,
    this.isLoading = false,
    this.hasReachedMax = false,
    this.filterQuery = '',
    this.showFavorites = false,
  });

  PokemonState copyWith({
    List<PokemonModel>? pokemons,
    List<PokemonModel>? filteredPokemons,
    List<PokemonModel>? favorites,
    bool? isLoading,
    bool? hasReachedMax,
    String? filterQuery,
    bool? showFavorites,
  }) {
    return PokemonState(
      pokemons: pokemons ?? this.pokemons,
      filteredPokemons: filteredPokemons ?? this.filteredPokemons,
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      filterQuery: filterQuery ?? this.filterQuery,
      showFavorites: showFavorites ?? this.showFavorites,
    );
  }
}
