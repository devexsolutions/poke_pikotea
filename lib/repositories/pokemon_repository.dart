import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:poke_pikotea/models/pokemon_detail_response_model.dart';
import 'package:poke_pikotea/models/pokemon_list_response_model.dart';

class PokemonRepository {
  final _dio = Dio();
  String url = 'https://pokeapi.co/api/v2/pokemon/';

  Future<List<PokemonModel>> fetchAllListPokemons(
      {int offset = 0, int limit = 20}) async {
    try {
      final response = await _dio.get('$url?offset=$offset&limit=$limit');
      final PokemonListResponseModel pokemonListResponseModel =
          PokemonListResponseModel.fromJson(response.data);
      final List<PokemonModel> pokemonList = pokemonListResponseModel.results!;

      return await parseResponse(pokemonList);
    } catch (e, stacktrace) {
      log(
        e.toString(),
        name: 'PokemonService.getPokemons',
        error: e,
        stackTrace: stacktrace,
      );
      throw e.toString();
    }
  }

  Future<List<PokemonModel>> parseResponse(
      List<PokemonModel> pokemonList) async {
    List<PokemonModel> pokemonListParsed = [];
    for (var pokemon in pokemonList) {
      final pokemonDetail = await getPokemonDetail(pokemon.name!);
      final String pokemonImage =
          pokemonDetail.sprites.other!.home.frontDefault;
      final List<String> pokemonAbilities =
          pokemonDetail.abilities.map((e) => e.ability.name).toList();
      pokemon.image = pokemonImage;
      pokemon.abilities = pokemonAbilities;
      pokemon.height = pokemonDetail.height;
      pokemon.weight = pokemonDetail.weight;
      pokemonListParsed.add(pokemon);
    }
    return pokemonListParsed;
  }

  Future<PokemonDetailResponseModel> getPokemonDetail(
      String pokemonName) async {
    try {
      final response = await _dio.get('$url$pokemonName');
      final PokemonDetailResponseModel pokemonDetailResponseModel =
          PokemonDetailResponseModel.fromJson(response.data);
      return pokemonDetailResponseModel;
    } on SocketException {
      throw Exception('Server error');
    } on HttpException {
      throw Exception('Something went wrong');
    } on FormatException {
      throw Exception('Bad request');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
