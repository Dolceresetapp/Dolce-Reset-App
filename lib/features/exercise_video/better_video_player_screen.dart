import 'package:flutter/material.dart';

import '../../networks/api_acess.dart';

class BetterVideoPlayerScreen extends StatefulWidget {
  final int id;
  const BetterVideoPlayerScreen({super.key, required this.id});

  @override
  State<BetterVideoPlayerScreen> createState() =>
      _BetterVideoPlayerScreenState();
}

class _BetterVideoPlayerScreenState extends State<BetterVideoPlayerScreen> {
  @override
  void initState() {
    workoutVideoRxObj.workoutVideoRx(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
