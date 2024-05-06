import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothScanner extends StatefulWidget {
  @override
  _BluetoothScannerState createState() => _BluetoothScannerState();
}

class _BluetoothScannerState extends State<BluetoothScanner> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    setState(() {
      isScanning = true;
      scanResults.clear();
    });

    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });

    Future.delayed(Duration(seconds: 4), () {
      flutterBlue.stopScan();
      setState(() {
        isScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scanner'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Available Devices:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            if (isScanning)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (scanResults.isEmpty)
              Center(
                child: Text('No devices found'),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: scanResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(scanResults[index].device.name ?? 'Unknown'),
                      subtitle: Text('RSSI: ${scanResults[index].rssi}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : startScan,
        tooltip: 'Scan',
        child: Icon(isScanning ? Icons.stop : Icons.bluetooth_searching),
        backgroundColor: isScanning ? Colors.red : Colors.blue,
      ),
    );
  }
}