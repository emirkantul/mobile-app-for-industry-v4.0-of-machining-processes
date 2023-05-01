import 'package:flutter/material.dart';
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

  final List<String> columnNames = [
    'Measurement Time',
    'Radial Depth',
    'Spindle Speed (RPM)',
    'Cut Speed',
    'Axial Depth (mm)',
    'Data/Rev',
    'Sampling Rate',
  ];

  final List<String> values = [
    '6.0',
    '6',
    '3720.0',
    '140',
    '0.25',
    '403',
    '25000'
  ]; 
 // TODO:  Get values dynamically
  final List<String> factorsColumnNames = [
    'Maximum',
    'Minimum',
    'Average',
    'Peak to Peak',
    'Variance',
    'Standard Deviation',
    'Skewness',
    'Form Factor',
    'Crest Factor',
    'Pulse Factor',
    'Margin Factor',
    'Gravity Center Frequency',
    'Mean Square Frequency',
    'Frequency Variance',
  ];

  List<String> factorsTimeValues = [];
  List<String> factorsSoundValues = [];
  List<String> factorsVibrationValues = [];

  @override
  void initState() {
    super.initState();
    _updateFactorsData(); // Load initial data for session 0
  }

  void _updateFactorsData() {
    setState(() {
      _factorData = widget.data;
      Map<String, double> tsvMaximum = tsvMax(_factorData);
      Map<String, double> tsvMinimum = tsvMin(_factorData);
      factorsTimeValues = [
        tsvMaximum['tMax']!.toStringAsFixed(3),
        tsvMinimum['tMin']!.toStringAsFixed(3),
        tsvAvg(_factorData)['tAvg']!.toStringAsFixed(3),
        tsvP2P(tsvMaximum, tsvMinimum)['tP2P']!.toStringAsFixed(3),
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
      ];

      factorsSoundValues = [
        tsvMaximum['sMax']!.toStringAsFixed(6),
        tsvMinimum['sMin']!.toStringAsFixed(6),
        tsvAvg(_factorData)['sAvg']!.toStringAsFixed(6),
        tsvP2P(tsvMaximum, tsvMinimum)['sP2P']!.toStringAsFixed(6),
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
      ];

      factorsVibrationValues = [
        tsvMaximum['vMax']!.toStringAsFixed(3),
        tsvMinimum['vMin']!.toStringAsFixed(3),
        tsvAvg(_factorData)['vAvg']!.toStringAsFixed(3),
        tsvP2P(tsvMaximum, tsvMinimum)['vP2P']!.toStringAsFixed(3),
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
        'WIP',
      ];
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
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
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
                            'Time',
                            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            'Sound',
                            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                          ),
                        ),
                        TableCell(
                          child: Text(
                            'Vibration',
                            style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                    for (int j = 0; j < factorsColumnNames.length; j++)
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              factorsColumnNames[j],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white70),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              factorsTimeValues[j],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white70),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              factorsSoundValues[j],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white70),
                            ),
                          ),
                          TableCell(
                            child: Text(
                              factorsVibrationValues[j],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white70),
                            ),
                          ),
                        ],
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
