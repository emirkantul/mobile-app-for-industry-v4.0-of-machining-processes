import 'session.dart';
import 'dart:math';

List<List<double>> splitIntoChunks<T>(List<double> list, int chunkLength) {
  List<List<double>> chunks = [];
  for (var i = 0; i < list.length; i += chunkLength) {
    chunks.add(list.sublist(i, i+chunkLength > list.length ? list.length : i + chunkLength));
  };
  return chunks;
}

List<double> maxValues(List<List<double>> list) {
  List<double> values = [];
  for(var i = 0; i < list.length; i++) {
    values.add(list[i].reduce((value, element) => max(value,element)));
  }
  return values;
}

Map<String, List<double>> tsvMax(List<TSV> data, int period) => {
      'tMax': maxValues(splitIntoChunks(data
          .map((e) => e.time).toList(), period)),
      'sMax': maxValues(splitIntoChunks(data
          .map((e) => e.sound).toList(), period)),
      'vMax': maxValues(splitIntoChunks(data
          .map((e) => e.vibration).toList(), period)),
    };

List<double> minValues(List<List<double>> list) {
  List<double> values = [];
  for(var i = 0; i < list.length; i++) {
    values.add(list[i].reduce((value, element) => min(value,element)));
  }
  return values;
}

Map<String, List<double>> tsvMin(List<TSV> data, int period) => {
      'tMin': minValues(splitIntoChunks(data
          .map((e) => e.time).toList(), period)),
      'sMin': minValues(splitIntoChunks(data
          .map((e) => e.sound).toList(), period)),
      'vMin': minValues(splitIntoChunks(data
          .map((e) => e.vibration).toList(), period)),
    };

List<double> avgValues(List<List<double>> list) {
  List<double> values = [];
  for(var i = 0; i < list.length; i++) {
    values.add(list[i].reduce((value, element) => (value + element) / list.length));
  }
  return values;
}

Map<String, List<double>> tsvAvg(List<TSV> data, int period) => {
      'tAvg':
        avgValues(splitIntoChunks(data
            .map((e) => e.time).toList(), period)),
      'sAvg':
        avgValues(splitIntoChunks(data
            .map((e) => e.sound).toList(), period)),
      'vAvg':
        avgValues(splitIntoChunks(data
            .map((e) => e.vibration).toList(), period)),
    };

List<double> p2pValues(List<double> maxList, List<double> minList) {
  List<double> values = [];
  for(var i = 0; i < maxList.length; i++) {
    values.add(maxList[i] - minList[i]);
  }
  return values;
}

Map<String, List<double>> tsvP2P(
        Map<String, List<double>> maxTsv, Map<String, List<double>> minTsv) =>
    {
      'tP2P': p2pValues(maxTsv['tMax']!, minTsv['tMin']!),
      'sP2P': p2pValues(maxTsv['sMax']!, minTsv['sMin']!),
      'vP2P': p2pValues(maxTsv['vMax']!, minTsv['vMin']!),
    };

List<double> varianceValues(List<List<double>> list) {
  List<double> values = [];
  for (var i = 0; i < list.length; i++) {
    var mean = list[i].reduce((value, element) => value + element) / list[i].length;
    var variance = list[i].fold<double>(
        0, (double prev, element) => prev + (element - mean) * (element - mean)) / list[i].length;
    var standardDeviation = sqrt(variance);
    values.add(standardDeviation / mean);
  }
  return values;
}


Map<String, List<double>> tsvVariance(
    Map<String, List<double>> maxTsv, Map<String, List<double>> minTsv) {
  List<List<double>> soundDiff = [];
  List<List<double>> vibrationDiff = [];

  for (var i = 0; i < maxTsv['sMax']!.length; i++) {
    soundDiff.add([maxTsv['sMax']![i] - minTsv['sMin']![i]]);
    vibrationDiff.add([maxTsv['vMax']![i] - minTsv['vMin']![i]]);
  }

  return {
    'tVariance': varianceValues(splitIntoChunks(maxTsv['tMax']!, 1)),
    'sVariance': varianceValues(soundDiff),
    'vVariance': varianceValues(vibrationDiff),
  };
}

List<double> standardDeviationValues(List<List<double>> list) {
  List<double> values = [];
  for (var i = 0; i < list.length; i++) {
    var mean = list[i].reduce((value, element) => value + element) / list[i].length;
    var variance = list[i].fold<double>(0, (prev, element) => prev + (element - mean) * (element - mean)) / list[i].length;
    var standardDeviation = sqrt(variance);
    values.add(standardDeviation);
  }
  return values;
}

Map<String, List<double>> tsvStandardDeviation(
    Map<String, List<double>> maxTsv, Map<String, List<double>> minTsv) {
  List<List<double>> soundDiff = [];
  List<List<double>> vibrationDiff = [];

  for (var i = 0; i < maxTsv['sMax']!.length; i++) {
    soundDiff.add([maxTsv['sMax']![i] - minTsv['sMin']![i]]);
    vibrationDiff.add([maxTsv['vMax']![i] - minTsv['vMin']![i]]);
  }

  return {
    'tStandardDeviation': standardDeviationValues(splitIntoChunks(maxTsv['tMax']!, 1)),
    'sStandardDeviation': standardDeviationValues(soundDiff),
    'vStandardDeviation': standardDeviationValues(vibrationDiff),
  };
}





