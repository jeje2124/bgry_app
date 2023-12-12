import 'package:bgry_app/attendanceForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String _barcode = 'NOT YET SCAN';

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    setState(() {
      _barcode = barcodeScanRes;
    });
  }

  Future<void> _saveData() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    setState(() {
      _barcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AttendanceForm()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('QR Code Scanner', style: TextStyle(fontSize: 30)),
      ),
      body: Container(
        color: Colors.orange[300], // Set the background color to light purple
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Scanned  QR Code:',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 16),
              Text(
                _barcode,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200, // Set the desired width for the buttons
                child: FloatingActionButton.extended(
                  onPressed: _saveData,
                  label: const Text('Save'),
                  icon: const Icon(Icons.save),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(
                  height: 16), // Adjust the space between buttons if needed
              SizedBox(
                width: 200, // Set the same width for the buttons
                child: FloatingActionButton.extended(
                  onPressed: _scanBarcode,
                  label: const Text('Scan QR Code'),
                  icon: const Icon(Icons.camera_alt),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
