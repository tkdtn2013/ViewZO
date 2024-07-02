import 'package:flutter/material.dart';
import 'package:viewzo/viewzo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter example ViewZO'),
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
  final List<String> _list = [
    "https://cdn.pixabay.com/photo/2023/05/07/01/55/man-7975388_1280.png",
    "https://cdn.pixabay.com/animation/2022/12/05/15/23/15-23-06-837_512.gif",
    "https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf"
  ];
  bool _mode = false;

  void _incrementList() {
    setState(() {
      _list.add(
        "https://cdn.pixabay.com/photo/2023/05/07/01/55/man-7975388_1280.png");
      _list.add(
        "https://cdn.pixabay.com/animation/2022/12/05/15/23/15-23-06-837_512.gif");
      _list.add(
          "https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf");
    });
  }

  void _changeMode() {
    setState(() {
      _mode = !_mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            ViewZo(
              items: _list,
              isPage: _mode,
              fit: BoxFit.fitWidth,
              scrollBarThumbColor: Colors.red.withOpacity(0.5),
              scrollBarThumbWidth: 10,
              scrollBarThumbRadius: const Radius.circular(5),
              headers: const {'Content-Type': 'application/json'},
            ),
            Positioned.fill(
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: _changeMode,
                    child: const Text('모드 변경'),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementList,
          child: const Icon(Icons.add),
        ));
  }
}
