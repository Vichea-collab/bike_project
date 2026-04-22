import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../models/bike_station.dart';
import '../../dtos/bike_station_dto.dart';

export 'bike_station_mock_repository.dart';

abstract class BikeStationRepository {
  Future<List<BikeStation>> fetchStations();
  Stream<List<BikeStation>> watchStations();
}

class BikeStationRestRepository implements BikeStationRepository {
  BikeStationRestRepository({required String databaseUrl, http.Client? client})
    : databaseUrl = databaseUrl.replaceFirst(RegExp(r'/$'), ''),
      _client = client ?? http.Client();

  final String databaseUrl;
  final http.Client _client;

  Uri _uri(String path, [Map<String, String>? queryParameters]) => Uri.parse(
    '$databaseUrl/$path.json',
  ).replace(queryParameters: queryParameters);

  @override
  Future<List<BikeStation>> fetchStations() async {
    final response = await _client.get(_uri('stations'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to fetch stations.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      return <BikeStation>[];
    }

    final stations = <BikeStation>[];
    for (final entry in decoded.entries) {
      final value = entry.value;
      if (value is Map) {
        stations.add(
          BikeStationDto.fromMap(
            entry.key,
            Map<Object?, Object?>.from(value),
          ).toDomain(),
        );
      }
    }

    stations.sort((a, b) => a.name.compareTo(b.name));
    return stations;
  }

  @override
  Stream<List<BikeStation>> watchStations() async* {
    yield await fetchStations();
    yield* Stream.periodic(
      const Duration(seconds: 5),
    ).asyncMap((_) => fetchStations());
  }
}
