import 'dart:typed_data';

import 'package:fftea/fftea.dart';

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

bool IsPowerOfTwo(int x)
{
  return (x & (x - 1)) == 0;
}

List<TopValuesFFT> fftValues(List<List<double>> list, int fftCount, double samplesPerSecond) {
  List<TopValuesFFT> values = [];
  for (var i = 0; i < list.length; i++) {

    if (!IsPowerOfTwo(list[i].length)) { // If length is power of two, then no problem
      int power = 1;
      while(power < list[i].length)
        power*=2;
      while(list[i].length < power) {
        list[i].add(0);
      }
    }

    final fft = FFT(list[i].length);
    final fftreq = fft.realFft(list[i]);

    var magnitudes = fftreq.discardConjugates().magnitudes();
    TopValuesFFT topMagnitudes = findTopValues(magnitudes, fftCount, fft, samplesPerSecond);

    values.add(topMagnitudes);
  }
  return values;
}


TopValuesFFT findTopValues(List<double> values, int count, FFT fft, double samplesPerSecond) {
  List<double> sortedValues = List.from(values); // Create a copy of the original list
  sortedValues.sort((a, b) => b.compareTo(a)); // Sort the list in descending order

  List<double> topValues = sortedValues.sublist(0, count); // Get the top 'count' values
  List<double> frequencies = [];
  for (int i = 0; i < count; i++) {
    int index = values.indexOf(topValues[i]);
    double frequency = fft.frequency(index, samplesPerSecond);
    frequencies.add(frequency);
  }


  return TopValuesFFT(magnitudes: topValues, frequencies: frequencies);
}

List<double> gravityCenterFrequencyValues(List<List<double>> list, int fftCount, double samplesPerSecond) {
  List<double> values = [];
  List<TopValuesFFT> fftResults = fftValues(list, fftCount, samplesPerSecond);
  for (var i = 0; i < fftResults.length; i++) {
    double magnitudeTimesFrequencySum = 0;
    double magnitudeSum = 0;
    for(var j = 0; j < fftResults[i].magnitudes.length; j++) {
      magnitudeTimesFrequencySum += fftResults[i].magnitudes[j]*fftResults[i].frequencies[j];
      magnitudeSum += fftResults[i].magnitudes[j];
    }

    values.add(magnitudeTimesFrequencySum/magnitudeSum);
  }
  return values;
}

Map<String, List<double>> tsvGravityCenterFrequency(List<TSV> list, int period, int fftCount, double samplesPerSecond) {

  return {
    'tGravityCenterFrequency': gravityCenterFrequencyValues(splitIntoChunks(list
        .map((e) => e.time).toList(), period), fftCount, samplesPerSecond),
    'sGravityCenterFrequency': gravityCenterFrequencyValues(splitIntoChunks(list
        .map((e) => e.sound).toList(), period), fftCount, samplesPerSecond),
    'vGravityCenterFrequency': gravityCenterFrequencyValues(splitIntoChunks(list
        .map((e) => e.vibration).toList(), period), fftCount, samplesPerSecond),
  };
}

List<double> meanSquareFrequencyValues(List<List<double>> list, int fftCount, double samplesPerSecond) {
  List<double> values = [];
  List<TopValuesFFT> fftResults = fftValues(list, fftCount, samplesPerSecond);
  for (var i = 0; i < fftResults.length; i++) {
    double magnitudeTimesFrequencySum = 0;
    double magnitudeSum = 0;
    for(var j = 0; j < fftResults[i].magnitudes.length; j++) {
      magnitudeTimesFrequencySum += pow(fftResults[i].magnitudes[j], 2)*fftResults[i].frequencies[j];
      magnitudeSum += fftResults[i].magnitudes[j];
    }

    values.add(magnitudeTimesFrequencySum/magnitudeSum);
  }
  return values;
}

Map<String, List<double>> tsvMeanSquareFrequency(List<TSV> list, int period, int fftCount, double samplesPerSecond) {

  return {
    'tMeanSquareFrequency': meanSquareFrequencyValues(splitIntoChunks(list
        .map((e) => e.time).toList(), period), fftCount, samplesPerSecond),
    'sMeanSquareFrequency': meanSquareFrequencyValues(splitIntoChunks(list
        .map((e) => e.sound).toList(), period), fftCount, samplesPerSecond),
    'vMeanSquareFrequency': meanSquareFrequencyValues(splitIntoChunks(list
        .map((e) => e.vibration).toList(), period), fftCount, samplesPerSecond),
  };
}




