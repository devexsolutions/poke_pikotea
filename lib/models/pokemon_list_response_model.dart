class PokemonListResponseModel {
  int? count;
  String? next;
  String? previous;
  List<PokemonModel>? results;

  PokemonListResponseModel(
      {required this.count,
      required this.next,
      required this.previous,
      required this.results});

  PokemonListResponseModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <PokemonModel>[];
      json['results'].forEach((v) {
        results!.add(PokemonModel.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'PokemonListResponseModel(count: $count, next: $next, previous: $previous, results: $results)';
  }
}

class PokemonModel {
  String? name;
  String? url;
  String? image;
  List<String>? abilities;
  int? height;
  int? weight;

  PokemonModel({
    this.name,
    this.url,
    this.image,
    this.abilities,
    this.height,
    this.weight,
  });

  PokemonModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    image = json['image'];
    abilities = json['abilities'];
    height = json['height'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name!.toUpperCase();
    data['url'] = url;
    data['image'] = image;
    data['abilities'] = abilities;
    data['height'] = height;
    data['weight'] = weight;
    return data;
  }

  @override
  String toString() =>
      'Result(name: $name, url: $url, image: $image, abilities: $abilities)';
}
