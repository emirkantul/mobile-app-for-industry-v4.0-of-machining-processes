import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class _vibrationData {
  final double value;
  final double time;

  _vibrationData({required this.value, required this.time});
}

class _soundData {
  final double value;
  final double time;

  _soundData({required this.value, required this.time});
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bottom Nav Demo',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF2F495E,
          <int, Color>{
            50: Color(0xFFE3F2FD),
            100: Color(0xFFBBDEFB),
            200: Color(0xFF90CAF9),
            300: Color(0xFF64B5F6),
            400: Color(0xFF42A5F5),
            500: Color(0xFF2196F3),
            600: Color(0xFF1E88E5),
            700: Color(0xFF1976D2),
            800: Color(0xFF1565C0),
            900: Color(0xFF0D47A1),
          },
        ),
      ),
      home: const HomePage(title: 'Past Sessions'),
    );
		}
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Map<String, Map<String, double>> _dataList = {};
  bool _isLoading = true;
  String _selectedDropdownValue = '1';

  static const List<String> _appBarTitles = <String>[
    'Past Sessions',
    'Last Session',
  ];

  List<Map<String, double>> _vibrationData = [];
  List<Map<String, double>> _soundData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Read multiple files using rootBundle
      List<String> fileNames = [
        'AL7075_chatter_sound_vibro_t_001.lvm',
        'AL7075_chatter_sound_vibro_t_002.lvm',
        'AL7075_chatter_sound_vibro_t_003.lvm',
        'AL7075_chatter_sound_vibro_t_004.lvm',
        'AL7075_chatter_sound_vibro_t_005.lvm',
        'AL7075_chatter_sound_vibro_t_006.lvm',
        'AL7075_chatter_sound_vibro_t_007.lvm',
        'AL7075_chatter_sound_vibro_t_008.lvm',
        'AL7075_chatter_sound_vibro_t_009.lvm',
        'AL7075_chatter_sound_vibro_t_010.lvm',
        'AL7075_chatter_sound_vibro_t_011.lvm',
        'AL7075_chatter_sound_vibro_t_012.lvm',
        'AL7075_chatter_sound_vibro_t_013.lvm',
        'AL7075_chatter_sound_vibro_t_014.lvm',
        'AL7075_chatter_sound_vibro_t_015.lvm',
        'AL7075_chatter_sound_vibro_t_016.lvm',
        'AL7075_chatter_sound_vibro_t_017.lvm',
        'AL7075_chatter_sound_vibro_t_018.lvm',
        'AL7075_chatter_sound_vibro_t_019.lvm',
        'AL7075_chatter_sound_vibro_t_020.lvm',
        'AL7075_chatter_sound_vibro_t_021.lvm',
        'AL7075_chatter_sound_vibro_t_022.lvm',
        'AL7075_chatter_sound_vibro_t_023.lvm',
        'AL7075_chatter_sound_vibro_t_024.lvm',
        'AL7075_chatter_sound_vibro_t_025.lvm',
        'AL7075_chatter_sound_vibro_t_026.lvm',
        'AL7075_chatter_sound_vibro_t_027.lvm',
        'AL7075_chatter_sound_vibro_t_028.lvm',
        'AL7075_chatter_sound_vibro_t_029.lvm'
      ];
      Map<String, Map<String, double>> data = {};

      for (var i = 0; i < fileNames.length; i++) {
        String content =
            await rootBundle.loadString('assets/data/${fileNames[i]}');
        List<String> lines = content.split('\n');
        for (var j = 0; j < lines.length; j++) {
          List<String> tsv = lines[i].split('\t');
          data[i.toString()] = {
            't': double.parse(tsv[0].replaceAll(',', '.')),
            's': double.parse(tsv[1].replaceAll(',', '.')),
            'v': double.parse(tsv[2].replaceAll(',', '.')),
          };
        }
      }

      setState(() {
        _dataList = data;
        _isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /*
    build-function
  */
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Widget bodyWidget;

    if (_isLoading) {
      bodyWidget = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      bodyWidget = Center(
        child: Text(_selectedIndex.toString()),
      );
    }

    _dataList.forEach((key, value) {
      _vibrationData
          .add({"time": value["t"] ?? 0.0, "vibration": value["v"] ?? 0.0});
      _soundData.add({"time": value["t"] ?? 0.0, "sound": value["s"] ?? 0.0});
    });

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(_appBarTitles[_selectedIndex]),
        ),
        actions: <Widget>[
          /*
            dropdown-widget
          */
          DropdownButton<String>(
            value: _selectedDropdownValue,
            onChanged: 
              (String? newValue, List<Map<String, double>> newVibration,  List<Map<String, double>> newSound) {
                  setState(() {
                    _selectedDropdownValue = newValue!;
                    _vibrationData = newVibration;
                    _soundData = newSound;
                  }));
            items: _dataList.keys
                .toList()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      /*
        charts
      */
      body: Column(
        children: [
          /*
          vibration
        */
          Expanded(
            child: SfCartesianChart(
              title: ChartTitle(text: "Vibration/Time"),
              legend: Legend(isVisible: true),
              series: <ChartSeries>[
                LineSeries<Map<String, double>, double>(
                  dataSource: _vibrationData,
                  xValueMapper: (Map<String, double> data, _) => data["time"],
                  yValueMapper: (Map<String, double> data, _) =>
                      data["vibration"],
                  name: "Vibration",
                ),
              ],
              primaryXAxis: NumericAxis(),
              primaryYAxis: NumericAxis(),
            ),
          ),
          /*
          sound
        */
          Expanded(
            child: SfCartesianChart(
              title: ChartTitle(text: "Sound/Time"),
              legend: Legend(isVisible: true),
              series: <ChartSeries>[
                LineSeries<Map<String, double>, double>(
                  dataSource: _soundData,
                  xValueMapper: (Map<String, double> data, _) => data["time"],
                  yValueMapper: (Map<String, double> data, _) => data["sound"],
                  name: "Sound",
                ),
              ],
              primaryXAxis: NumericAxis(),
              primaryYAxis: NumericAxis(),
            ),
          ),
        ],
      ),
      /*
        navigation-bar
      */
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Past Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_sync),
            label: 'Last Session',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
