import 'session.dart';
import 'dart:math';

Map<String, double> tsvMax(List<TSV> data) => {
      'tMax': data
          .map((e) => e.time)
          .reduce((value, element) => max(value, element)),
      'sMax': data
          .map((e) => e.sound)
          .reduce((value, element) => max(value, element)),
      'vMax': data
          .map((e) => e.vibration)
          .reduce((value, element) => max(value, element)),
    };

Map<String, double> tsvMin(List<TSV> data) => {
      'tMin': data
          .map((e) => e.time)
          .reduce((value, element) => min(value, element)),
      'sMin': data
          .map((e) => e.sound)
          .reduce((value, element) => min(value, element)),
      'vMin': data
          .map((e) => e.vibration)
          .reduce((value, element) => min(value, element)),
    };

Map<String, double> tsvAvg(List<TSV> data) => {
      'tAvg':
          data.map((e) => e.time).reduce((value, element) => value + element) /
              data.length,
      'sAvg':
          data.map((e) => e.sound).reduce((value, element) => value + element) /
              data.length,
      'vAvg':
          data.map((e) => e.sound).reduce((value, element) => value + element) /
              data.length,
    };

Map<String, double> tsvP2P(
        Map<String, double> maxTsv, Map<String, double> minTsv) =>
    {
      'tP2P': maxTsv['tMax']! - minTsv['tMin']!,
      'sP2P': maxTsv['sMax']! - minTsv['sMin']!,
      'vP2P': maxTsv['vMax']! - minTsv['vMin']!,
    };
