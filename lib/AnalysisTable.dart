import 'package:flutter/material.dart';

class AnalysisTable extends StatelessWidget {
  final List<String> columnNames = [
    't',
    'b',
    'RPM',
    'V',
    'a(mm)',
    'rev/s',
    'data/rev',
    'sampling rate'
  ];

  final List<String> values = [
    '6.0',
    '6',
    '3720.0',
    '140',
    '0.25',
    '62',
    '403',
    '25000'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Analysis Table',
        ),
        foregroundColor: Colors.white70,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analysis',
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
          ],
        ),
      ),
    );
  }
}
