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
          "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/abd61545-e61b-43e5-a4bc-e9dcff4b7b4e/dgsy9y9-8c3df2eb-a266-439b-8fdc-165d116a62b9.jpg/v1/fit/w_632,h_1800,q_70,strp/neo_webtoon_project_sample_panel_1_by_chromaticlevelstudio_dgsy9y9-375w-2x.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MjI4MCIsInBhdGgiOiJcL2ZcL2FiZDYxNTQ1LWU2MWItNDNlNS1hNGJjLWU5ZGNmZjRiN2I0ZVwvZGdzeTl5OS04YzNkZjJlYi1hMjY2LTQzOWItOGZkYy0xNjVkMTE2YTYyYjkuanBnIiwid2lkdGgiOiI8PTgwMCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.XdcbHqCpH4D6pUGY82UVS_PAGttNcrVdL_gxZcRruMc");
      _list.add(
          "https://i.pinimg.com/originals/1a/13/2d/1a132dee024ad10ac3a14dcb69ca0755.gif");
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
