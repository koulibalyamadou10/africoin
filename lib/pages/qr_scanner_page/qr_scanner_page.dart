import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:africoin/widgets/custom_appbar.dart';

// Écran de scanner QR
class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Scanner QR Code'),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                if (_dialogShown) return;
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  _dialogShown = true;
                  _processQRData(barcodes.first.rawValue!);
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scannez le QR code du destinataire',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processQRData(String data) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('QR Code scanné'),
            content: Text('Données: $data'),
            actions: [
              TextButton(
                onPressed: () {
                  _dialogShown = false;
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
