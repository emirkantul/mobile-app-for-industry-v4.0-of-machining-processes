import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'AnalysisTable.dart';

/*
  data-types
*/
class TSV {
  final double time;
  final double sound;
  final double vibration;

  TSV({required this.time, required this.sound, required this.vibration});
}

class Session extends StatefulWidget {
  Map<String, List<TSV>> tsvData = {};

  Session({
    super.key,
    required this.tsvData,
  });

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  bool _isLoading = true;
  String _selectedDropdownValue = '0-xxxxxxxx';
  List<TSV> _chartData = [];
  late TrackballBehavior _trackballBehaviorVibration;
  late TrackballBehavior _trackballBehaviorSound;
  late ZoomPanBehavior _zoomBehaviorVibration;
  late ZoomPanBehavior _zoomBehaviorSound;
  /*
    init-state
  */
  @override
  void initState() {
    super.initState();
    _trackballBehaviorVibration = TrackballBehavior(enable: true);
    _zoomBehaviorVibration = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
    );
    _trackballBehaviorSound = TrackballBehavior(enable: true);
    _zoomBehaviorSound = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
    );
    _updateChartData('0-xxxxxxxx'); // Load initial data for session 0
  }

  /* 
    update-tsv-data
  */
  void _updateChartData(String selectedDropdownValue) {
    setState(() {
      _chartData = shrinkDataStrategy(widget.tsvData[selectedDropdownValue]!);
      _isLoading = false;
    });
  }

  /*
    shrinks data for drawing on charts without performance issues
  */
  List<TSV> shrinkDataStrategy(List<TSV> tsvs) {
    List<TSV> shrinked = [];
    int targetDataLength = 13000; // 13000 seems to be the cap for charts

    if (tsvs.length > targetDataLength) {
      // data is too large, apply average downsampling
      int shrinkFactor = (tsvs.length / targetDataLength).ceil();

      double timeSum = 0;
      double vibrationSum = 0;
      double soundSum = 0;
      var factorCount = 1;

      for (var i = 0; i < tsvs.length; i++) {
        timeSum += tsvs[i].time;
        vibrationSum += tsvs[i].vibration;
        soundSum += tsvs[i].sound;

        if (factorCount == shrinkFactor) {
          TSV values = TSV(
              time: timeSum / shrinkFactor,
              sound: soundSum / shrinkFactor,
              vibration: vibrationSum / shrinkFactor);
          shrinked.add(values);
          timeSum = 0;
          soundSum = 0;
          vibrationSum = 0;
          factorCount = 1;
        } else {
          factorCount += 1;
        }
      }
    } else {
      // data is small enough to not cause performance problems
      shrinked = tsvs;
    }

    return shrinked;
  }

  void _zoomInVib() {
    _zoomBehaviorVibration.zoomIn();
  }

  void _zoomOutVib() {
    _zoomBehaviorVibration.zoomOut();
  }

  void _zoomOutSound() {
    _zoomBehaviorSound.zoomOut();
  }

  void _zoomInSound() {
    _zoomBehaviorSound.zoomIn();
  }

// TODO: add analysis table
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnalysisTable()),
            );
          },
          child: const Text('Table'),
        ),
        backgroundColor: Colors.grey.shade900,
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900, //<-- SEE HERE
            ),
            child: DropdownButton<String>(
              dropdownColor: Colors.grey.shade800,
              value: _selectedDropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDropdownValue = newValue!;
                  _updateChartData(_selectedDropdownValue);
                });
                // updateChartData(_selectedDropdownValue);
              },
              items: widget.tsvData.keys.toList().map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  );
                },
              ).toList(),
              iconEnabledColor: const Color(0xFFE3F2FD),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 600,
                        child: SfCartesianChart(
                          title: ChartTitle(text: "Vibration/Time"),
                          legend: Legend(isVisible: true),
                          series: <ChartSeries>[
                            FastLineSeries<TSV, double>(
                              color: Colors.green.shade800,
                              dataSource: _chartData,
                              xValueMapper: (TSV data, _) =>
                                  data.time * 10000.0,
                              yValueMapper: (TSV data, _) => data.vibration,
                              name: "Vibration",
                              animationDuration: 0,
                            ),
                          ],
                          primaryXAxis: NumericAxis(),
                          primaryYAxis: NumericAxis(),
                          trackballBehavior: _trackballBehaviorVibration,
                          zoomPanBehavior: _zoomBehaviorVibration,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: _zoomInVib,
                                    ),
                                  ),
                                  SizedBox(
                                    child: IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: _zoomOutVib,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                "Zoom",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 600,
                        child: SfCartesianChart(
                          title: ChartTitle(text: "Sound/Time"),
                          legend: Legend(isVisible: true),
                          series: <ChartSeries>[
                            FastLineSeries<TSV, double>(
                              color: Colors.green.shade800,
                              dataSource: _chartData,
                              xValueMapper: (TSV data, _) =>
                                  data.time * 10000.0,
                              yValueMapper: (TSV data, _) => data.sound,
                              name: "Sound",
                              animationDuration: 0,
                            ),
                          ],
                          primaryXAxis: NumericAxis(),
                          primaryYAxis: NumericAxis(),
                          trackballBehavior: _trackballBehaviorSound,
                          zoomPanBehavior: _zoomBehaviorSound,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: _zoomInSound,
                                    ),
                                  ),
                                  SizedBox(
                                    child: IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: _zoomOutSound,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                "Zoom",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
