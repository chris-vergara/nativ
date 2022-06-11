import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nativ/data/model/place.dart';
import 'package:nativ/data/model/place_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  var mag = dotenv.get('GOOGLE_MAPS_MAGNOLIA');

  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(regions)&types=(cities)&key=$mag');

    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((e) => PlaceSearch.fromJson(e)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?key=$mag&place_id=$placeId');

    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResults);
  }
}
