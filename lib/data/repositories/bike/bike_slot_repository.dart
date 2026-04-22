import 'dart:convert';

import 'package:http/http.dart' as http;

export 'bike_slot_mock_repository.dart';

abstract class BikeSlotRepository {
  Future<void> bookBike({required String stationId, required String slotId});
}

class BikeSlotRestRepository implements BikeSlotRepository {
  BikeSlotRestRepository({required String databaseUrl, http.Client? client})
    : databaseUrl = databaseUrl.replaceFirst(RegExp(r'/$'), ''),
      _client = client ?? http.Client();

  final String databaseUrl;
  final http.Client _client;

  Uri _uri(String path, [Map<String, String>? queryParameters]) => Uri.parse(
    '$databaseUrl/$path.json',
  ).replace(queryParameters: queryParameters);

  @override
  Future<void> bookBike({
    required String stationId,
    required String slotId,
  }) async {
    final slotUri = _uri('stations/$stationId/slots/$slotId');

    final getResponse = await _client.get(
      slotUri,
      headers: const {'X-Firebase-ETag': 'true'},
    );

    if (getResponse.statusCode < 200 || getResponse.statusCode >= 300) {
      throw Exception('Unable to load the selected bike slot.');
    }

    final etag = getResponse.headers['etag'];
    final decoded = jsonDecode(getResponse.body);

    if (etag == null || decoded is! Map) {
      throw Exception('Invalid bike slot response.');
    }

    final currentSlot = Map<String, dynamic>.from(decoded);
    if (currentSlot['isAvailable'] != true) {
      throw Exception('Bike is no longer available.');
    }

    final updatedSlot = <String, dynamic>{...currentSlot, 'isAvailable': false};

    final putResponse = await _client.put(
      slotUri,
      headers: {'if-match': etag, 'content-type': 'application/json'},
      body: jsonEncode(updatedSlot),
    );

    if (putResponse.statusCode == 412) {
      throw Exception('Bike is no longer available.');
    }

    if (putResponse.statusCode < 200 || putResponse.statusCode >= 300) {
      throw Exception('Unable to confirm the booking.');
    }
  }
}
