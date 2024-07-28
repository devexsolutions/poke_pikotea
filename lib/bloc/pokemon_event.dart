// Definición de eventos
import 'package:poke_pikotea/models/pokemon_list_response_model.dart';

abstract class PokemonEvent {}

class FetchPokemons extends PokemonEvent {
  final int offset;
  final int limit;

  FetchPokemons({this.offset = 0, this.limit = 20});
}

class ToggleFavorite extends PokemonEvent {
  final PokemonModel pokemon;

  ToggleFavorite(this.pokemon);
}

class FilterPokemons extends PokemonEvent {
  final String query;
  final bool showFavorites;

  FilterPokemons({this.query = '', this.showFavorites = false});
}
