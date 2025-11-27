import 'package:easy_countdown/easy_countdown.dart';
import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final EasyCountdownController _countdownController = EasyCountdownController(
    onProgress: (value) {
      print('controller status: ${value.status}');
    },
  );

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EasyCountdown(
              controller: _countdownController,
              config: CountDownConfig(
                duration: Duration(seconds: 10000),
                autoPlay: true,
                onDone: () {
                  print('done');
                },
              ),
              builder: (context, value, status) {
                return Text(CountdownFormatUtils.formatHHmmss(value));
              },
            ),

            ElevatedButton(
              onPressed: () {
                _countdownController.reset();
              },
              child: Text('重新开始'),
            ),

            ElevatedButton(
              onPressed: () {
                _countdownController.start();
              },
              child: Text('开始'),
            ),

            ElevatedButton(
              onPressed: () {
                _countdownController.pause();
              },
              child: Text('暂停'),
            ),
          ],
        ),
      ),
    );
  }
}
