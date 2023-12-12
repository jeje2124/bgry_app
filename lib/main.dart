import 'package:bgry_app/attendanceForm.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter UI',
    theme: ThemeData(primarySwatch: Colors.purple),
    home: const AttendanceForm(),
  ));
}
