import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'session.dart';

void main() => runApp(const App());

/*
  app-top-bar
*/
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile App for Industry v4.0 Milling Process',
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

/*
  home-page
*/
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*
    initializations
  */
  int _selectedTabIndex = 0;
  bool _isLoading = true;
  Map<String, List<TSV>> _tsvData = {};
  static const List<String> _appBarTitles = <String>[
    'Past Sessions',
    'Last Session',
  ];

  /*
    init-state
  */
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /*
    load-static-data
  */
  Future<void> _loadData() async {
    try {
      _isLoading = true;

      // Read multiple files using rootBundle
      List<String> fileNames = [
        'AL7075_chatter_sound_vibro_t_001.lvm',
        'AL7075_chatter_sound_vibro_t_002.lvm',
        // 'AL7075_chatter_sound_vibro_t_003.lvm',
        // 'AL7075_chatter_sound_vibro_t_004.lvm',
        // 'AL7075_chatter_sound_vibro_t_005.lvm',
        // 'AL7075_chatter_sound_vibro_t_006.lvm',
        // 'AL7075_chatter_sound_vibro_t_007.lvm',
        // 'AL7075_chatter_sound_vibro_t_008.lvm',
        // 'AL7075_chatter_sound_vibro_t_009.lvm',
        // 'AL7075_chatter_sound_vibro_t_010.lvm',
        // 'AL7075_chatter_sound_vibro_t_011.lvm',
        // 'AL7075_chatter_sound_vibro_t_012.lvm',
        // 'AL7075_chatter_sound_vibro_t_013.lvm',
        // 'AL7075_chatter_sound_vibro_t_014.lvm',
        // 'AL7075_chatter_sound_vibro_t_015.lvm',
        // 'AL7075_chatter_sound_vibro_t_016.lvm',
        // 'AL7075_chatter_sound_vibro_t_017.lvm',
        // 'AL7075_chatter_sound_vibro_t_018.lvm',
        // 'AL7075_chatter_sound_vibro_t_019.lvm',
        // 'AL7075_chatter_sound_vibro_t_020.lvm',
        // 'AL7075_chatter_sound_vibro_t_021.lvm',
        // 'AL7075_chatter_sound_vibro_t_022.lvm',
        // 'AL7075_chatter_sound_vibro_t_023.lvm',
        // 'AL7075_chatter_sound_vibro_t_024.lvm',
        // 'AL7075_chatter_sound_vibro_t_025.lvm',
        // 'AL7075_chatter_sound_vibro_t_026.lvm',
        // 'AL7075_chatter_sound_vibro_t_027.lvm',
        // 'AL7075_chatter_sound_vibro_t_028.lvm',
        // 'AL7075_chatter_sound_vibro_t_029.lvm'
      ];
      Map<String, List<TSV>> allTsv = {};
      List<TSV> tsvs = [];

      for (var i = 0; i < fileNames.length; i++) {
        String content =
            await rootBundle.loadString('assets/data/${fileNames[i]}');
        List<String> lines = content.split('\n');

        for (var j = 0; j < lines.length; j++) {
          List<String> tsvLine = lines[i].split('\t');
          tsvs.add(TSV(
            time: double.parse(tsvLine[0].replaceAll(',', '.')),
            sound: double.parse(tsvLine[1].replaceAll(',', '.')),
            vibration: double.parse(tsvLine[2].replaceAll(',', '.')),
          ));
        }

        allTsv["$i-xxxxxxxx"] = tsvs; // TODO: add session date
      }

      setState(() {
        _isLoading = false;
        _tsvData = allTsv;
      });
    } catch (error) {
      log("Error on load-static-data: $error");
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  /*
    build-function
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(_appBarTitles[_selectedTabIndex]),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Session(
              tsvData: _tsvData,
            ),
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
        currentIndex: _selectedTabIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
