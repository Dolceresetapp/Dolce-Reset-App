import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../provider/cache_video_provider.dart';

class CacheVideoScreen extends StatefulWidget {
  final int id;
  const CacheVideoScreen({super.key, required this.id});
  @override
  State<CacheVideoScreen> createState() => _CacheVideoScreenState();
}

class _CacheVideoScreenState extends State<CacheVideoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CacheVideoProvider>().getData(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CacheVideoProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Cached Video Player')),
          body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: provider.data.length,
            onPageChanged: provider.onPageChanged,
            itemBuilder: (context, index) {
              if (index == provider.currentIndex &&
                  provider.controller != null &&
                  provider.controller!.value.isInitialized) {
                return AspectRatio(
                  aspectRatio: provider.controller!.value.aspectRatio,
                  child: VideoPlayer(provider.controller!),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}
