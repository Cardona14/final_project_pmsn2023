import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class Place {
  String? ubicationName;
  double? lat;
  double? lot;

  Place({
    this.ubicationName,
    this.lat,
    this.lot,
  });
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = 'AIzaSyCXvh-TsB2PpHV7Yz31NUzHc8QkoLeScsQ';
  final apiKey = androidKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final Uri request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:mx&key=$apiKey&sessiontoken=$sessionToken');

    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final Uri request = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=&key=$apiKey&sessiontoken=$sessionToken');

    print(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey&sessiontoken=$sessionToken');
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final city = result['result']['formatted_address'];
        final geo = result['result']['geometry']['location'];
        // build result
        final place = Place();

        place.ubicationName = city;
        place.lat = geo['lat'];
        place.lot = geo['lng'];

        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
