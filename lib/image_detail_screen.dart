import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailScreen extends StatefulWidget {
  final List<String> imageUrls;
  final String active;

  const ImageDetailScreen({
    super.key,
    required this.imageUrls,
    required this.active,
  });

  @override
  ImageDetailScreenState createState() => ImageDetailScreenState();
}

class ImageDetailScreenState extends State<ImageDetailScreen> {
  late String active;
  late List<String> imageUrls;
  bool isVisible = true;
  final PhotoViewController pvController = PhotoViewController();


  @override
  void initState() {
    super.initState();
    imageUrls = widget.imageUrls;
    active = widget.active;
  }

  @override
  void dispose() {
    pvController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: toggleVisibility,
            child: PhotoView(
              controller: pvController,
              scaleStateChangedCallback: (value) {
                setState(() {
                  isVisible = PhotoViewScaleState.initial == value;
                });
              },
              imageProvider: NetworkImage(active),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              initialScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: active),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: event == null 
                        ? 0 
                        : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                  ),
                ),
              ),
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(Icons.error, color: Colors.white, size: 50),
              )
            ),
          ),
          if (isVisible) ...[
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white, size: 25),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.white, size: 25),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ],
      ),
    );
  }
}