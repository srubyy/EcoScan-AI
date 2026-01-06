import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'waste_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(); // Turn on the database connection
  runApp(const MaterialApp(home: EcoScanHome()));
}

class EcoScanHome extends StatefulWidget {
  const EcoScanHome({super.key});

  @override
  State<EcoScanHome> createState() => _EcoScanHomeState();
}

class _EcoScanHomeState extends State<EcoScanHome> {
  File? _image;
  String _result = "Scan an item to see magic!";
  bool _loading = false;
  final WasteService _wasteService = WasteService();

  Future<void> _scanItem() async {
    final picker = ImagePicker();
    // This opens the camera automatically
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _image = File(photo.path);
        _loading = true; // Show loading spinner
      });

      // Send photo to the AI brain
      String analysis = await _wasteService.identifyWaste(_image!);

      setState(() {
        _result = analysis; // Show the answer
        _loading = false; // Hide loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EcoScan AI ♻️")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Area to show the photo
            Expanded(
              child: _image == null
                  ? const Center(child: Text("No image captured"))
                  : Image.file(_image!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            // Area to show the text result
            Container(
              padding: const EdgeInsets.all(15),
              color: Colors.green.shade50,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : Text(_result, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            // The Scan Button
            ElevatedButton.icon(
              onPressed: _scanItem,
              icon: const Icon(Icons.camera_alt),
              label: const Text("SCAN WASTE"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}