import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bottom Nav Demo',
      theme: ThemeData(
        primarySwatch: MaterialColor(
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
      home: HomePage(title: 'Past Sessions'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<String> _appBarTitles = <String>[
    'Past Sessions',
    'Last Session',
  ];

  Map<String, Map<String, double>> _dataList = {};
  bool _isLoading = true;
  String _selectedDropdownValue = '1';

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

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    if (_isLoading) {
      bodyWidget = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      bodyWidget = Center(
        child: Text(_selectedIndex.toString()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(_appBarTitles[_selectedIndex]),
        ),
        actions: <Widget>[
          // Add the DropdownButton widget here
          DropdownButton<String>(
            value: _selectedDropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                _selectedDropdownValue = newValue!;
              });
            },
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
      body: bodyWidget,
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
