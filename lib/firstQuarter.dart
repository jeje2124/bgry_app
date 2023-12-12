import 'dart:convert' as convert;
import 'package:bgry_app/qr_generator.dart';
import 'package:bgry_app/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_response.dart';

class FirstQuarter extends StatefulWidget {
  const FirstQuarter ({Key? key}) : super(key: key);

  @override
  _FirstQuarterState createState() => _FirstQuarterState();
}

class _FirstQuarterState extends State<FirstQuarter> {
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController venueController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _addAttendance() async {
    var data = {
      'date': selectedDate,
      'venue': venueController.text,
      'about': aboutController.text,
    };

    var result = await CallApi()
        .postData(data, 'attendance'); // You need to define the CallApi class
    var body = convert.jsonDecode(result.body);

    if (body != null &&
        body.containsKey('success') &&
        body['success'] is bool &&
        body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(
          'attendance', convert.jsonEncode(body['attendance']));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Scanner()));

      // Show a SnackBar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance added successfully',
              style: TextStyle(fontSize: 20)),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Handle error or non-success case
      // You can add error handling logic or show a message to the user here

      // Show a SnackBar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add attendance. Please try again.',
              style: TextStyle(
                fontSize: 20,
              )),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  void initState() {
    super.initState();
    // Initialize controllers and set default values
    venueController = TextEditingController();
    aboutController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    venueController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("First Quarter Assembly Form"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text(
                      'Date: $selectedDate',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date',
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Venue',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 30),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'About',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30), // Add space above the buttons
          SizedBox(
            width: 200,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Add functionality for the first button here
              },
              label: const Text(
                'Submit',
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Colors.orange,
            ),
          ),
          const SizedBox(height: 20), // Add space between the buttons
          SizedBox(
            width: 200,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Scanner()),
                );
              },
              label: const Text(
                'Scan QR Code',
                style: TextStyle(fontSize: 20),
              ),
              icon: const Icon(Icons.camera_alt),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}