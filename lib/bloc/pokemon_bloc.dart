import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_pikotea/bloc/pokemon_event.dart';
import 'package:poke_pikotea/bloc/pokemon_state.dart';
import 'package:poke_pikotea/models/pokemon_list_response_model.dart';
import 'package:poke_pikotea/repositories/pokemon_repository.dart';

// BLoC
class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository repository;

  PokemonBloc(this.repository)
      : super(PokemonState(pokemons: [], filteredPokemons: [], favorites: [])) {
    on<FetchPokemons>(_onFetchPokemons);
    on<ToggleFavorite>(_onToggleFavorite);
    on<FilterPokemons>(_onFilterPokemons);
  }

  // Manejo de FetchPokemons
  Future<void> _onFetchPokemons(
      FetchPokemons event, Emitter<PokemonState> emit) async {
    if (state.hasReachedMax) return;
    emit(state.copyWith(isLoading: true));
    try {
      final newPokemons = await repository.fetchAllListPokemons(
          offset: event.offset, limit: event.limit);
      emit(state.copyWith(
        pokemons: List.of(state.pokemons)..addAll(newPokemons),
        filteredPokemons: _applyFilters(
          pokemons: List.of(state.pokemons)..addAll(newPokemons),
          query: state.filterQuery,
          showFavorites: state.showFavorites,
        ),
        isLoading: false,
        hasReachedMax: newPokemons.isEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Handle error
    }
  }

  // Manejo de ToggleFavorite
  void _onToggleFavorite(ToggleFavorite event, Emitter<PokemonState> emit) {
    final newFavorites = List<PokemonModel>.from(state.favorites);
    if (newFavorites.contains(event.pokemon)) {
      newFavorites.remove(event.pokemon);
    } else {
      newFavorites.add(event.pokemon);
    }
    emit(state.copyWith(
      favorites: newFavorites,
      filteredPokemons: _applyFilters(
        pokemons: state.pokemons,
        query: state.filterQuery,
        showFavorites: state.showFavorites,
        favorites: newFavorites,
      ),
    ));
  }

  // Manejo de FilterPokemons
  void _onFilterPokemons(FilterPokemons event, Emitter<PokemonState> emit) {
    emit(state.copyWith(
      filterQuery: event.query,
      showFavorites: event.showFavorites,
      filteredPokemons: _applyFilters(
        pokemons: state.pokemons,
        query: event.query,
        showFavorites: event.showFavorites,
        favorites: state.favorites,
      ),
    ));
  }

  // Aplicar filtros
  List<PokemonModel> _applyFilters({
    required List<PokemonModel> pokemons,
    required String query,
    required bool showFavorites,
    List<PokemonModel>? favorites,
  }) {
    List<PokemonModel> filtered = pokemons;
    if (query.isNotEmpty) {
      filtered = filtered
          .where((pokemon) =>
              pokemon.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    if (showFavorites) {
      filtered =
          filtered.where((pokemon) => favorites!.contains(pokemon)).toList();
    }
    return filtered;
  }
}
