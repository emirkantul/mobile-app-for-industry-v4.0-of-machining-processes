import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  /*
    init-state
  */
  @override
  void initState() {
    super.initState();
    _updateChartData('0-xxxxxxxx'); // Load initial data for session 0
  }

  /* 
    update-tsv-data
  */
  void _updateChartData(String selectedDropdownValue) {
    setState(() {
      _chartData = widget.tsvData[selectedDropdownValue]!;
      _isLoading = false;
    });
  }

// TODO: add analysis table
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.indigo, //<-- SEE HERE
            ),
            child: DropdownButton<String>(
              value: _selectedDropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDropdownValue = newValue!;
                });
                // updateChartData(_selectedDropdownValue);
              },
              items: widget.tsvData.keys.toList().map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
                  // TODO: fix charts and do research on library
                  child: SfCartesianChart(
                    title: ChartTitle(text: "Vibration/Time"),
                    legend: Legend(isVisible: true),
                    series: <ChartSeries>[
                      LineSeries<TSV, double>(
                        dataSource: _chartData,
                        xValueMapper: (TSV data, _) => data.time * 10000.0,
                        yValueMapper: (TSV data, _) => data.vibration,
                        name: "Vibration",
                      ),
                    ],
                    primaryXAxis: NumericAxis(),
                    primaryYAxis: NumericAxis(),
                  ),
                ),
                Expanded(
                  child: SfCartesianChart(
                    title: ChartTitle(text: "Sound/Time"),
                    legend: Legend(isVisible: true),
                    series: <ChartSeries>[
                      LineSeries<TSV, double>(
                        dataSource: _chartData,
                        xValueMapper: (TSV data, _) => data.time * 10000.0,
                        yValueMapper: (TSV data, _) => data.sound,
                        name: "Sound",
                      ),
                    ],
                    primaryXAxis: NumericAxis(),
                    primaryYAxis: NumericAxis(),
                  ),
                ),
              ],
            ),
    );
  }
}
