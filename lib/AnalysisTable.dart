import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fftea/fftea.dart';
import 'session.dart';
import 'analysis.dart';

class AnalysisTable extends StatefulWidget {
  List<TSV> data = [];

  AnalysisTable({
    super.key,
    required this.data,
  });

  @override
  State<AnalysisTable> createState() => _AnalysisTableState();
}

class _AnalysisTableState extends State<AnalysisTable> {
  List<TSV> _factorData = [];
  List<TSV> _maximumData = [];
  List<TSV> _minimumData = [];
  List<TSV> _averageData = [];
  List<TSV> _P2PData = [];
  List<TSV> _varianceData = [];
  List<TSV> _standardDeviationData = []; // New list for standard deviation form factor values
  List<TSV> _gravityCenterFrequencyData = [];

  final revolutionsCount = TextEditingController();
  final fftCount = TextEditingController();

  final List<String> columnNames = [
    'Measurement Time',
    'Radial Depth',
    'Spindle Speed (RPM)',
    'Cut Speed',
    'Axial Depth (mm)',
    'Data/Rev',
    'Sampling Rate',
  ];

  final List<String> values = [ // TODO:  Get values dynamically
    '6.0',
    '6',
    '3720.0',
    '140',
    '0.25',
    '403',
    '25000'
  ]; 


  List<String> factorsTimeValues = [];
  List<String> factorsSoundValues = [];
  List<String> factorsVibrationValues = [];

  late TrackballBehavior _trackballBehaviorMaximumVibration;
  late TrackballBehavior _trackballBehaviorMaximumSound;
  late TrackballBehavior _trackballBehaviorMinimumVibration;
  late TrackballBehavior _trackballBehaviorMinimumSound;
  late TrackballBehavior _trackballBehaviorAverageVibration;
  late TrackballBehavior _trackballBehaviorAverageSound;
  late TrackballBehavior _trackballBehaviorPeakToPeakVibration;
  late TrackballBehavior _trackballBehaviorPeakToPeakSound;
  late TrackballBehavior _trackballBehaviorVarianceSound;
  late TrackballBehavior _trackballBehaviorVarianceVibration;
  late TrackballBehavior _trackballBehaviorSTDDevSound;
  late TrackballBehavior _trackballBehaviorSTDDevVibration;
  late TrackballBehavior _trackballBehaviorGravityCenterSound;
  late TrackballBehavior _trackballBehaviorGravityCenterVibration;


  @override
  void initState() {
    super.initState();
    _trackballBehaviorMaximumVibration = TrackballBehavior(enable: true);
    _trackballBehaviorMaximumSound = TrackballBehavior(enable: true);
    _trackballBehaviorMinimumVibration = TrackballBehavior(enable: true);
    _trackballBehaviorMinimumSound = TrackballBehavior(enable: true);
    _trackballBehaviorAverageVibration = TrackballBehavior(enable: true);
    _trackballBehaviorAverageSound = TrackballBehavior(enable: true);
    _trackballBehaviorPeakToPeakVibration = TrackballBehavior(enable: true);
    _trackballBehaviorPeakToPeakSound = TrackballBehavior(enable: true);
    _trackballBehaviorVarianceSound = TrackballBehavior(enable: true);
    _trackballBehaviorVarianceVibration = TrackballBehavior(enable: true);
    _trackballBehaviorSTDDevSound = TrackballBehavior(enable: true);
    _trackballBehaviorSTDDevVibration = TrackballBehavior(enable: true);
    _trackballBehaviorGravityCenterSound = TrackballBehavior(enable: true);
    _trackballBehaviorGravityCenterVibration = TrackballBehavior(enable: true);



    _updateFactorsData(20, 5); // Load initial data for session 0*/
  }

  void _updateFactorsData(int period, int fftCount) {
  setState(() {
    var analysisPeriod = 403 * period; // TODO: Change 403 to data/rev
    double samplingFrequency = 25000; //TODO: Change 25000 to sampling rate
    _factorData = widget.data;

    var tempMaximum = tsvMax(_factorData, analysisPeriod);
    var tempMinimum = tsvMin(_factorData, analysisPeriod);
    var tempAverage = tsvAvg(_factorData, analysisPeriod);
    var tempP2P = tsvP2P(tempMaximum, tempMinimum);
    var tempVariance = tsvVariance(tempMaximum, tempMinimum); // New line for variance calculation
    var tempStandardDeviation = tsvStandardDeviation(tempMaximum, tempMinimum); // New line for standard deviation calculation
    var tempGravityCenterFrequency = tsvGravityCenterFrequency(_factorData, analysisPeriod, fftCount, samplingFrequency);
    var tempTime = tempMaximum['tMax'];

    List<TSV> maximumValues = [];
    List<TSV> minimumValues = [];
    List<TSV> averageValues = [];
    List<TSV> peakToPeakValues = [];
    List<TSV> varianceValues = []; // New list for variance form factor values
    List<TSV> standardDeviationValues = []; // New list for standard deviation form factor values
    List<TSV> gravityCenterFrequencyValues = [];

    for (var i = 0; i < tempTime!.length; i++) {
      maximumValues.add(TSV(
        time: tempTime[i],
        sound: tempMaximum['sMax']![i],
        vibration: tempMaximum['vMax']![i],
      ));
      minimumValues.add(TSV(
        time: tempTime[i],
        sound: tempMinimum['sMin']![i],
        vibration: tempMinimum['vMin']![i],
      ));
      averageValues.add(TSV(
        time: tempTime[i],
        sound: tempAverage['sAvg']![i],
        vibration: tempAverage['vAvg']![i],
      ));
      peakToPeakValues.add(TSV(
        time: tempTime[i],
        sound: tempP2P['sP2P']![i],
        vibration: tempP2P['vP2P']![i],
      ));
      varianceValues.add(TSV(
        time: tempTime[i],
        sound: tempVariance['sVariance']![i], // Assigning the sound variance form factor values
        vibration: tempVariance['vVariance']![i], // Assigning the vibration variance form factor values
      ));
      standardDeviationValues.add(TSV(
        time: tempTime[i],
        sound: tempStandardDeviation['sStandardDeviation']![i], // Assigning the sound standard deviation form factor values
        vibration: tempStandardDeviation['vStandardDeviation']![i], // Assigning the vibration standard deviation form factor values
      ));
      gravityCenterFrequencyValues.add(TSV(
        time: tempTime[i],
        sound: tempGravityCenterFrequency['sGravityCenterFrequency']![i],
        vibration: tempGravityCenterFrequency['vGravityCenterFrequency']![i],
      ));
    }
    _maximumData = maximumValues;
    _minimumData = minimumValues;
    _averageData = averageValues;
    _P2PData = peakToPeakValues;
    _varianceData = varianceValues; // Assigning the variance form factor values
    _standardDeviationData = standardDeviationValues; // Assigning the standard deviation form factor values
    _gravityCenterFrequencyData = gravityCenterFrequencyValues;
  });
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Cutting Conditions Table',
        ),
        foregroundColor: Colors.white70,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cutting Conditions',
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
                const SizedBox(height: 16.0),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(0.5),
                  },
                  border: TableBorder.all(color: Colors.blueGrey, width: 0.1),
                  children: [
                    const TableRow(
                      children: [
                        TableCell(
                          child: Text(
                            'Name',
                            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            'Value',
                            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < columnNames.length; i++)
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              columnNames[i],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white70),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              values[i],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Chatter Detected: ",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      const Text(
                        "No", // dummy output for now
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Form Factors',
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child:
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            hintText: 'Enter rev',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: TextStyle(color: Colors.white70),
                          controller: revolutionsCount,
                          keyboardType: TextInputType.number,
                        ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    OutlinedButton(
                      child: Text("Calculate"),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _updateFactorsData(int.parse(revolutionsCount.text=="" ? "20" : revolutionsCount.text), int.parse(fftCount.text=="" ? "5" : fftCount.text));
                      },
                    ),
                  ],
                ),

                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Maximum Vibration/Time",
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _maximumData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.vibration,
                            name: "Vibration",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorMaximumVibration,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Maximum Sound/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _maximumData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.sound,
                            name: "Sound",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorMaximumSound,
                        ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Minimum Vibration/Time",
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _minimumData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.vibration,
                            name: "Vibration",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorMinimumVibration,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Minimum Sound/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _minimumData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.sound,
                            name: "Sound",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorMinimumSound,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Average Vibration/Time",
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _averageData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.vibration,
                            name: "Vibration",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorAverageVibration,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Average Sound/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _averageData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.sound,
                            name: "Sound",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorAverageSound,
                      ),
                    ),

                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "PeakToPeak Vibration/Time",
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _P2PData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.vibration,
                            name: "Vibration",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorPeakToPeakVibration,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Variance Sound/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _P2PData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.sound,
                            name: "Sound",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorVarianceSound,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Variance Vibration/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _P2PData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.vibration,
                            name: "Vibration",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorVarianceVibration,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "STD Dev Sound/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _P2PData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.sound,
                            name: "Sound",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorSTDDevSound,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "STD Dev Vibration/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _P2PData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.vibration,
                            name: "Vibration",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorSTDDevVibration,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child:
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          hintText: 'FFT: Choose X values with top magnitude',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: TextStyle(color: Colors.white70),
                        controller: fftCount,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    OutlinedButton(
                      child: Text("Calculate FFT"),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        side: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _updateFactorsData(int.parse(revolutionsCount.text=="" ? "20" : revolutionsCount.text), int.parse(fftCount.text=="" ? "5" : fftCount.text));
                      },
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Gravity Center Frequency Sound/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _gravityCenterFrequencyData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.sound,
                            name: "Sound",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorGravityCenterSound,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 600,
                      height: 200,
                      child: SfCartesianChart(
                        title: ChartTitle(text: "Gravity Center Frequency Vibration/Time" ,
                            textStyle: TextStyle(color: Colors.grey)),
                        legend: Legend(isVisible: false),
                        series: <ChartSeries>[
                          FastLineSeries<TSV, double>(
                            color: Colors.green.shade800,
                            dataSource: _gravityCenterFrequencyData,
                            xValueMapper: (TSV data, _) =>
                            data.time * 10000.0,
                            yValueMapper: (TSV data, _) => data.vibration,
                            name: "Vibration",
                            animationDuration: 0,
                          ),
                        ],
                        primaryXAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.grey)),
                        trackballBehavior: _trackballBehaviorGravityCenterVibration,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}
