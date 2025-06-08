

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'paged_wall.dart';
import 'picture_item.dart';
import 'api.dart';
import 'image_detail_screen.dart';

void main() {
  FlutterError.onError = (details) {
    // 记录到错误跟踪系统
    debugPrint('Caught Flutter error: $details');
    debugPrint('Stack trace: ${details.stack}');
  };
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
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const pageSize = 20; // 每页加载数量
  final PagingController<int, String> pagingController = PagingController(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + pageSize,
    fetchPage: (int off) => fetchPictures(off, pageSize),
  );
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Null jmpDetail(String hash) {
    final imageUrls = pagingController.items?.map(
      (item) => getPreviewUrl(item)
    ).toList();

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ImageDetailScreen(
        imageUrls: imageUrls ?? [],
        active: getPreviewUrl(hash)
      ),
    ));
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,  // 可以指定文件類型：image, video, audio, any等
        allowMultiple: true,  // 是否允許多選
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('選擇文件失敗: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Text('data')
        ),
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 200,
        drawerScrimColor: Color(0xaa000000),
        drawer: Drawer(
          child: [
            Container(
              decoration: BoxDecoration(color: Color(0xffff0000)),
            ),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('選擇文件'),
            ),
          ]
        ),
        body: PagedWall<String>(
          pagingController: pagingController,
          itemBuilder: (context, item, index) => PictureItem(
            imageUrl: getThumbwUrl(item),
            onPressed: () => jmpDetail(item)
          )
        )
    );
  }
}
