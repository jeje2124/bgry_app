import 'dart:convert' as convert;

import 'package:bgry_app/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_response.dart'; // Import your custom API handling code here
import 'package:bgry_app/firstQuarter.dart';
import 'package:bgry_app/secondQuarter.dart';
import 'package:bgry_app/thirdQuarter.dart';
import 'package:bgry_app/fourthQuarter.dart';

class AttendanceForm extends StatefulWidget {
  const AttendanceForm({Key? key}) : super(key: key);

  @override
  _AttendanceFormState createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  String selectedAssemblyType = "First Quarter Assembly";
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController venueController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  Future<void> _addAttendance() async {
    var data = {
      'assembly_type': selectedAssemblyType,
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Scanner()));

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
    var size = MediaQuery.of(context).size;
    const double verticalSpacing = 30.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple, // Start color
              Colors.amber,
              // Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42.0),
          child: ListView(
            children: [
              const SizedBox(height: verticalSpacing + 30),
              Container(
                height: size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          height: 180.0,
                          child: const Image(
                            fit: BoxFit.fitWidth,
                            image: AssetImage("images/1.png"),
                          )),
                    ),
                    const Text(
                        "Barangay Imbatug \n Attendance  QR Code Scanner App",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30.0, color: Colors.white)),
                    const SizedBox(height: verticalSpacing + 1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: verticalSpacing),
                        Row(
                          children: [
                            const SizedBox(width: 40.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FirstQuarter()),
                                );
                              },
                              child: const Text(
                                'First Quarter Assembly',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            SizedBox(
                                height:
                                    10), // Adding margin to the bottom of the ElevatedButton
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SecondQuarter()),
                                );
                              },
                              child: const Text(
                                'Second Quarter Assembly',
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            SizedBox(
                                height:
                                    80), // Adding margin to the bottom of the ElevatedButton
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ThirdQuarter()),
                                );
                              },
                              child: const Text(
                                'Third Quarter Assembly',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            SizedBox(
                                height:
                                    80), // Adding margin to the bottom of the ElevatedButton
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 40.0),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FourthQuarter()),
                                );
                              },
                              child: const Text(
                                'Fourth Quarter Assembly',
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                                height:
                                    80), // Adding margin to the bottom of the ElevatedButton
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
