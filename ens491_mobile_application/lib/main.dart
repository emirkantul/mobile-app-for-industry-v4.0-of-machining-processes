import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Milling Mobile Application'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _LineChartSample2State();
}

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

class _LineChartSample2State extends State<MyHomePage> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         // Here we take the value from the MyHomePage object that was created by
         // the App.build method, and use it to set our appbar title.
         title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.70,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Color(0xff232d37),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 12,
                      top: 24,
                      bottom: 12,
                    ),
                    child: LineChart(
                      showAvg ? avgData() : mainData(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 34,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Text(
                    'avg',
                    style: TextStyle(
                      fontSize: 12,
                      color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

        ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('0s', style: style);
        break;
      case 1:
        text = const Text('1s', style: style);
        break;
      case 2:
        text = const Text('2s', style: style);
        break;
      case 3:
        text = const Text('3s', style: style);
        break;
      case 4:
        text = const Text('Time', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case -200:
        text = '-20K';
        break;
      case 0:
        text = '0';
        break;
      case 200:
        text = '20K';
        break;
      case 400:
        text = '40k';
        break;
      case 600:
        text = 'Vibration';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 5.2,
      minY: -250,
      maxY: 610,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0.02,-179.188),
            FlSpot(0.06,-165.08),
            FlSpot(0.1,-133.66),
            FlSpot(0.14,-124.997),
            FlSpot(0.18,-94.209),
            FlSpot(0.22,-76.237),
            FlSpot(0.26,-30.791),
            FlSpot(0.3,82.407),
            FlSpot(0.34,256.307),
            FlSpot(0.38,433.887),
            FlSpot(0.42,573.857),
            FlSpot(0.46,593.331),
            FlSpot(0.5,601.605),
            FlSpot(0.54,473.311),
            FlSpot(0.58,386.972),
            FlSpot(0.62,276.485),
            FlSpot(0.66,206.135),
            FlSpot(0.7,139.795),
            FlSpot(0.74,42.331),
            FlSpot(0.78,65.32),
            FlSpot(0.82,37.18),
            FlSpot(0.86,32.944),
            FlSpot(0.9,-15.755),
            FlSpot(0.94,-55.92),
            FlSpot(0.98,-96.096),
            FlSpot(1.02,-126.86),
            FlSpot(1.06,-161.905),
            FlSpot(1.1,-192.78),
            FlSpot(1.14,-209.778),
            FlSpot(1.18,-220.842),
            FlSpot(1.22,-234.848),
            FlSpot(1.26,-245.11),
            FlSpot(1.3,-247.539),
            FlSpot(1.34,-234.535),
            FlSpot(1.38,-219.684),
            FlSpot(1.42,-197.817),
            FlSpot(1.46,-188.999),
            FlSpot(1.5,-141.65),
            FlSpot(1.54,-114.117),
            FlSpot(1.58,-71.014),
            FlSpot(1.62,-46.461),
            FlSpot(1.66,-3.069),
            FlSpot(1.7,13.622),
            FlSpot(1.74,44.24),
            FlSpot(1.78,70.724),
            FlSpot(1.82,101.266),
            FlSpot(1.86,125.966),
            FlSpot(1.9,172.546),
            FlSpot(1.94,238.339),
            FlSpot(1.98,317.347),
            FlSpot(2.02,416.312),
            FlSpot(2.06,381.597),
            FlSpot(2.1,322.215),
            FlSpot(2.14,252.798),
            FlSpot(2.18,186.849),
            FlSpot(2.22,101.656),
            FlSpot(2.26,42.579),
            FlSpot(2.3,-15.381),
            FlSpot(2.34,-62.112),
            FlSpot(2.38,-101.037),
            FlSpot(2.42,-128.949),
            FlSpot(2.46,-126.292),
            FlSpot(2.5,-147.722),
            FlSpot(2.54,-229.921),
            FlSpot(2.58,-187.292),
            FlSpot(2.62,-41.443),
            FlSpot(2.66,-9.3),
            FlSpot(2.7,-32.118),
            FlSpot(2.74,-55.339),
            FlSpot(2.78,-75.416),
            FlSpot(2.82,-88.262),
            FlSpot(2.86,-102.21),
            FlSpot(2.9,-91.888),
            FlSpot(2.94,-111.205),
            FlSpot(2.98,-126.975),
            FlSpot(3.02,-115.577),
            FlSpot(3.06,-117.279),
            FlSpot(3.1,-106.07),
            FlSpot(3.14,-98.212),
            FlSpot(3.18,-73.846),
            FlSpot(3.22,-52.119),
            FlSpot(3.26,9.301),
            FlSpot(3.3,17.725),
            FlSpot(3.34,57.352),
            FlSpot(3.38,89.624),
            FlSpot(3.42,114.82),
            FlSpot(3.46,164.733),
            FlSpot(3.5,204.403),
            FlSpot(3.54,238.521),
            FlSpot(3.58,271.096),
            FlSpot(3.62,272.116),
            FlSpot(3.66,255.557),
            FlSpot(3.7,222.736),
            FlSpot(3.74,179.274),
            FlSpot(3.78,128.838),
            FlSpot(3.82,68.014),
            FlSpot(3.86,12.177),
            FlSpot(3.9,-34.879),
            FlSpot(3.94,-83.016),
            FlSpot(3.98,-113.494),
            FlSpot(4.02,-131.381),
            FlSpot(4.06,-138.081),
            FlSpot(4.1,-143.209),
            FlSpot(4.14,-141.318),
            FlSpot(4.18,-138.686),
            FlSpot(4.22,-136.914),
            FlSpot(4.26,-124.742),
            FlSpot(4.3,-116.124),
            FlSpot(4.34,-103.293),
            FlSpot(4.38,-88.736),
            FlSpot(4.42,-79.657),
            FlSpot(4.46,-72.046),
            FlSpot(4.5,-64.906),
            FlSpot(4.54,-60.641),
            FlSpot(4.58,-56.483),
            FlSpot(4.62,-51.785),
            FlSpot(4.66,-50.835),
            FlSpot(4.7,-48.73),
            FlSpot(4.74,-34.355),
            FlSpot(4.78,-27.032),
            FlSpot(4.82,-17.636),
            FlSpot(4.86,-12.247),
            FlSpot(4.9,-4.222),
            FlSpot(4.94,10.074),
            FlSpot(4.98,31.624),
            FlSpot(5.02,48.884),
            FlSpot(5.06,70.95),
            FlSpot(5.1,81.726),
            FlSpot(5.14,91.849),
            FlSpot(5.18,96.621),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
