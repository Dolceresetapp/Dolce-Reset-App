import 'package:flutter/material.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../networks/api_acess.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  Barcode? _barcode;
  bool _isNavigated = false;

  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan Food Barcode',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    final barcode = barcodes.barcodes.firstOrNull;

    if (barcode == null || _isNavigated) return;

    _isNavigated = true;
    final value = barcode.displayValue ?? 'Unknown';

    int scanCode = int.parse(value);

    await scanBarcodeRxObj
        .scanBarcodeRx(scanCode: scanCode)
        .then((scanModel) {
          setState(() {
            NavigationService.navigateToWithArgs(Routes.mealResultScreen, {
              "response": scanModel,
            });
          });
        })
        .then((_) {
          _isNavigated = false; // reset when returning
        });

    // if (isSuccess) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (_) => MealResultScreen()),
    //   ).then((_) {
    //     _isNavigated = false; // reset when returning
    //   });
    // }

    if (mounted) {
      setState(() => _barcode = barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _barcodePreview(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
